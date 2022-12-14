
&НаКлиенте
Процедура ЗагрузитьФаксимиле(Команда)
	Если Объект.ИспользованиеКлюча = ПредопределенноеЗначение("Перечисление.скEDI_ИспользованиеКлючей.Шифрование") Тогда
		Сообщить(НСтр("ru = 'Не доступно для сертификата Шифрования'; uk = 'Не доступно для сертифікату Шифрування'"));
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ТекстВопроса = НСтр("ru='Для выбора изображения необходимо записать объект. Записать?';uk=""Для вибору зображення необхідно записати об'єкт. Записати?""");

		Если скEDI_ОбщегоНазначения.ЭтоПлатформа82() Тогда
			Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет);
			Если Ответ = КодВозвратаДиалога.Да Тогда
				Если Записать() Тогда
					ПоместитьФаксимилеВХранилище();	
				КонецЕсли;	
			КонецЕсли;	
		Иначе	
			скEDI_ОткрытиеФормБезМодальности.ПоказатьВопросБезМодальности("ВопросЗаписьОбъектаЗавершение", ЭтаФорма,, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		КонецЕсли;
	Иначе
		ПоместитьФаксимилеВХранилище();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВопросЗаписьОбъектаЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт 
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Если Записать() Тогда
			ПоместитьФаксимилеВХранилище();	
		КонецЕсли;	
	КонецЕсли;
	
КонецПроцедуры	

&НаКлиенте
Процедура ПоместитьФаксимилеВХранилище() Экспорт
	АдресВХранилище = "";
	ВыбранноеИмяФайла = "";
	Если скEDI_ОбщегоНазначения.ЭтоПлатформа82() Тогда
		ДиалогВыбора = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
		ДиалогВыбора.Фильтр = НСтр("ru = 'Файлы изображений'; uk = 'Файли зображень'") + " (*.png)|*.png";
		ДиалогВыбора.Заголовок =НСтр("ru = 'Выберите файл факсимиле; uk = 'Виберіть файл факсиміле'");
		ДиалогВыбора.ПредварительныйПросмотр     = Истина;
		ДиалогВыбора.ИндексФильтра               = 0;
		ДиалогВыбора.ПолноеИмяФайла              = "";
		ДиалогВыбора.ПроверятьСуществованиеФайла = Истина;
		ДиалогВыбора.МножественныйВыбор          = Ложь;
		Если ДиалогВыбора.Выбрать() Тогда
			ВыбранноеИмяФайла = ДиалогВыбора.ПолноеИмяФайла;
			Если ПоместитьФайл(АдресВХранилище, ВыбранноеИмяФайла, , Ложь, УникальныйИдентификатор) Тогда
				ПослеПомещенияФайлаФаксимиле(Истина, АдресВХранилище, ВыбранноеИмяФайла);
			КонецЕсли;
		КонецЕсли;
	Иначе
		 скEDI_ОткрытиеФормБезМодальности.ВыбратьФайлФаксимиле(АдресВХранилище, ВыбранноеИмяФайла, УникальныйИдентификатор, ЭтаФорма);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПослеПомещенияФайлаФаксимиле(Результат, Адрес, ВыбранноеИмяФайла, ДополнительныеПараметры=Неопределено) Экспорт
	Если Результат Тогда
		Файл = Новый Файл(ВыбранноеИмяФайла);
		
		ИмяФайлаФаксимиле = Файл.Имя;
		СсылкаНаФайлФаксимиле = Адрес;
		
		Модифицированность = Результат;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	Если ЭтоАдресВременногоХранилища(СсылкаНаФайлФаксимиле) Тогда
		ДвоичныеДанные = ПолучитьИзВременногоХранилища(СсылкаНаФайлФаксимиле);
		
		МенеджерЗаписиФаксимиле = РегистрыСведений.скEDI_Факсимиле.СоздатьМенеджерЗаписи();
		МенеджерЗаписиФаксимиле.Подпись = Объект.Ссылка;
		МенеджерЗаписиФаксимиле.Факсимиле = Новый ХранилищеЗначения(ДвоичныеДанные);
		МенеджерЗаписиФаксимиле.ИмяФайла = ИмяФайлаФаксимиле;
		МенеджерЗаписиФаксимиле.Записать(Истина);
		
		УдалитьИзВременногоХранилища(СсылкаНаФайлФаксимиле);
		СсылкаНаФайлФаксимиле = ПолучитьНавигационнуюСсылку(РегистрыСведений.скEDI_Факсимиле.СоздатьКлючЗаписи(Новый Структура("Подпись", Объект.Ссылка)), "Факсимиле");
	КонецЕсли;
	СохранитьГруппыПодписиСервере();
	ЗаполнитьГруппыПодписиСервере();
	ЗаполнитьТаблицуПользователейСервере();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьГруппыПодписиСервере()
	ГруппыПодписи.Очистить();
	
	Если Объект.ИспользованиеКлюча = ПредопределенноеЗначение("Перечисление.скEDI_ИспользованиеКлючей.Подписание") Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		               |	скEDI_ГруппыПодписейСправочник.Ссылка КАК ГруппаПодписи,
		               |	ВЫБОР
		               |		КОГДА скEDI_ГруппыПодписейРегистр.Подпись ЕСТЬ NULL
		               |			ТОГДА ЛОЖЬ
		               |		ИНАЧЕ ИСТИНА
		               |	КОНЕЦ КАК ВходитВГруппу
		               |ИЗ
		               |	Справочник.скEDI_ГруппыПодписей КАК скEDI_ГруппыПодписейСправочник
		               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.скEDI_ГруппыПодписей КАК скEDI_ГруппыПодписейРегистр
		               |		ПО скEDI_ГруппыПодписейСправочник.Ссылка = скEDI_ГруппыПодписейРегистр.ГруппаПодписи
		               |			И (скEDI_ГруппыПодписейРегистр.Подпись = &Подпись)
		               |ГДЕ
		               |	(скEDI_ГруппыПодписейРегистр.Подпись ЕСТЬ НЕ NULL 
		               |			ИЛИ НЕ скEDI_ГруппыПодписейСправочник.Ссылка В (&ГруппыПодписейИсключение))
		               |
		               |УПОРЯДОЧИТЬ ПО
		               |	скEDI_ГруппыПодписейСправочник.Код";
		Запрос.УстановитьПараметр("Подпись", Объект.Ссылка);
		
		ГруппыПодписей = Новый СписокЗначений;
		Если Объект.Роль = ПредопределенноеЗначение("Перечисление.скEDI_РолиПодписей.ПечатьОрганизации") Тогда
			ГруппыПодписей.Добавить(ПредопределенноеЗначение("Справочник.скEDI_ГруппыПодписей.Бухгалтер"));
			ГруппыПодписей.Добавить(ПредопределенноеЗначение("Справочник.скEDI_ГруппыПодписей.ОтветственноеЛицо"));
			ГруппыПодписей.Добавить(ПредопределенноеЗначение("Справочник.скEDI_ГруппыПодписей.Руководитель"));
		ИначеЕсли Объект.Роль = ПредопределенноеЗначение("Перечисление.скEDI_РолиПодписей.ПодписьБухгалтера") Тогда
			ГруппыПодписей.Добавить(ПредопределенноеЗначение("Справочник.скEDI_ГруппыПодписей.Печать"));
			ГруппыПодписей.Добавить(ПредопределенноеЗначение("Справочник.скEDI_ГруппыПодписей.Руководитель"));
		ИначеЕсли Объект.Роль = ПредопределенноеЗначение("Перечисление.скEDI_РолиПодписей.ПодписьДиректора") Тогда
			ГруппыПодписей.Добавить(ПредопределенноеЗначение("Справочник.скEDI_ГруппыПодписей.Печать"));
			ГруппыПодписей.Добавить(ПредопределенноеЗначение("Справочник.скEDI_ГруппыПодписей.Бухгалтер"));
		ИначеЕсли Объект.Роль = ПредопределенноеЗначение("Перечисление.скEDI_РолиПодписей.ПодписьОтветственногоЛица") Тогда
			ГруппыПодписей.Добавить(ПредопределенноеЗначение("Справочник.скEDI_ГруппыПодписей.Печать"));
			ГруппыПодписей.Добавить(ПредопределенноеЗначение("Справочник.скEDI_ГруппыПодписей.Руководитель"));
			ГруппыПодписей.Добавить(ПредопределенноеЗначение("Справочник.скEDI_ГруппыПодписей.Бухгалтер"));
		ИначеЕсли Объект.Роль = ПредопределенноеЗначение("Перечисление.скEDI_РолиПодписей.ПодписьФизическогоЛица") Тогда
			ГруппыПодписей.Добавить(ПредопределенноеЗначение("Справочник.скEDI_ГруппыПодписей.Печать"));
			ГруппыПодписей.Добавить(ПредопределенноеЗначение("Справочник.скEDI_ГруппыПодписей.Руководитель"));
			ГруппыПодписей.Добавить(ПредопределенноеЗначение("Справочник.скEDI_ГруппыПодписей.Бухгалтер"));
			ГруппыПодписей.Добавить(ПредопределенноеЗначение("Справочник.скEDI_ГруппыПодписей.ДопДокументыДФС"));
		Иначе
		КонецЕсли;
		Запрос.УстановитьПараметр("ГруппыПодписейИсключение", ГруппыПодписей);
		ВыборкаРезультатаЗапроса = Запрос.Выполнить().Выбрать();
		Пока ВыборкаРезультатаЗапроса.Следующий() Цикл
			НоваяСтрока = ГруппыПодписи.Добавить();
			НоваяСтрока.ГруппаПодписи = ВыборкаРезультатаЗапроса.ГруппаПодписи;
			НоваяСтрока.ВходитВГруппу = ВыборкаРезультатаЗапроса.ВходитВГруппу;
			НоваяСтрока.ВходитВГруппуКеш = ВыборкаРезультатаЗапроса.ВходитВГруппу;
		КонецЦикла;
	КонецЕсли;
	Элементы.ГруппыПодписи.Доступность = ЗначениеЗаполнено(Объект.Ссылка) и (Объект.ИспользованиеКлюча = ПредопределенноеЗначение("Перечисление.скEDI_ИспользованиеКлючей.Подписание"));
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Объект.Пользователи.Очистить();
	Для Каждого СтрокаТаблицыПользователей из ТаблицаПользователей Цикл
		Если СтрокаТаблицыПользователей.ЕстьДоступ Тогда
			НовыйЭлементПользователи = Объект.Пользователи.Добавить();
			НовыйЭлементПользователи.Пользователь = СтрокаТаблицыПользователей.Пользователь;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуПользователейСервере()
	ТаблицаПользователей.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Пользователи.Ссылка КАК Ссылка,
	               |	Пользователи.Наименование КАК Наименование
	               |ИЗ
	               |	Справочник.Пользователи КАК Пользователи";
	ВыборкаРезультатаЗапроса = Запрос.Выполнить().Выбрать();
	
	Пока ВыборкаРезультатаЗапроса.Следующий() Цикл
		НовыйЭлементТаблицыПользователей = ТаблицаПользователей.Добавить();
		НовыйЭлементТаблицыПользователей.Пользователь = ВыборкаРезультатаЗапроса.Ссылка;
		
		МассивВыбраныхПользователей = Объект.Пользователи.НайтиСтроки(Новый Структура("Пользователь", ВыборкаРезультатаЗапроса.Ссылка));
		Если МассивВыбраныхПользователей.Количество() > 0 Тогда
			НовыйЭлементТаблицыПользователей.ЕстьДоступ = Истина;
		КонецЕсли;
		
		НовыйЭлементТаблицыПользователей.Контроль = ПланыВидовХарактеристик.скEDI_НастройкиПользователей.ПолучитьЗначениеНастройки(НовыйЭлементТаблицыПользователей.Пользователь, ПредопределенноеЗначение("ПланВидовХарактеристик.скEDI_НастройкиПользователей.ТолькоДоступныеПодписи"));
	КонецЦикла;
	ТаблицаПользователей.Сортировать("ЕстьДоступ Desc, Пользователь");
	Если ПланыВидовХарактеристик.скEDI_НастройкиПользователей.ЕстьДоступРедактироватьНастройку(ПредопределенноеЗначение("ПланВидовХарактеристик.скEDI_НастройкиПользователей.ТолькоДоступныеПодписи")) Тогда
		Элементы.ТаблицаПользователейКонтроль.ТолькоПросмотр = Ложь;
	Иначе
		Элементы.ТаблицаПользователейКонтроль.ТолькоПросмотр = Истина;
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ТаблицаПользователейКонтрольИзмененитьНаСервере(Пользователь, Значение)
	ПланыВидовХарактеристик.скEDI_НастройкиПользователей.УстановитьЗначениеНастройки(Пользователь, ПредопределенноеЗначение("ПланВидовХарактеристик.скEDI_НастройкиПользователей.ТолькоДоступныеПодписи"), Значение);
КонецПроцедуры


&НаКлиенте
Процедура ТаблицаПользователейКонтрольПриИзменении(Элемент)
	ТекущиеДанные = Элементы.ТаблицаПользователей.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ТаблицаПользователейКонтрольИзмененитьНаСервере(ТекущиеДанные.Пользователь, ТекущиеДанные.Контроль);
		Оповестить("скEDI_ИзмененоЗначениеНастройкиПользователя_ТолькоДоступныеПодписи", ТекущиеДанные.Пользователь, ЭтаФорма);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура СохранитьГруппыПодписиСервере()
	ГруппыПодписиИзмененоВхождение.Очистить();
	Для Каждого ГруппаПодписи Из ГруппыПодписи Цикл
		Если ГруппаПодписи.ВходитВГруппуКеш <> ГруппаПодписи.ВходитВГруппу Тогда
			ГруппыПодписиИзмененоВхождение.Добавить(ГруппаПодписи.ГруппаПодписи);
			ГруппыПодписейМенеджерЗаписи = РегистрыСведений.скEDI_ГруппыПодписей.СоздатьМенеджерЗаписи();
			ГруппыПодписейМенеджерЗаписи.Подпись = Объект.Ссылка;
			ГруппыПодписейМенеджерЗаписи.ГруппаПодписи = ГруппаПодписи.ГруппаПодписи;
			Если ГруппаПодписи.ВходитВГруппу Тогда
				ГруппыПодписейМенеджерЗаписи.Записать(Истина);
			Иначе
				ГруппыПодписейМенеджерЗаписи.Удалить();
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЗаполнитьГруппыПодписиСервере();
	ЗаполнитьТаблицуПользователейСервере();
	СсылкаНаФайлФаксимиле = ПолучитьНавигационнуюСсылку(РегистрыСведений.скEDI_Факсимиле.СоздатьКлючЗаписи(Новый Структура("Подпись", Объект.Ссылка)), "Факсимиле");
КонецПроцедуры

&НаСервере
Функция ПроверитьНаличиеФаксимилеНаСервере(ИмяФайла)
	МенеджерЗаписиФаксимиле = РегистрыСведений.скEDI_Факсимиле.СоздатьМенеджерЗаписи();	
	МенеджерЗаписиФаксимиле.Подпись = Объект.Ссылка;
	МенеджерЗаписиФаксимиле.Прочитать();
	Если МенеджерЗаписиФаксимиле.Выбран() Тогда
		ИмяФайла = МенеджерЗаписиФаксимиле.ИмяФайла;
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли; 
КонецФункции

&НаСервере
Процедура УдалитьФаксимилеНаСервере()
	МенеджерЗаписиФаксимиле = РегистрыСведений.скEDI_Факсимиле.СоздатьМенеджерЗаписи();	
	МенеджерЗаписиФаксимиле.Подпись = Объект.Ссылка;
	МенеджерЗаписиФаксимиле.Удалить();
КонецПроцедуры

&НаКлиенте
Процедура СохранитьФаксимиле(Команда)
	ИмяФайла = "";
	Если ПроверитьНаличиеФаксимилеНаСервере(ИмяФайла) Тогда
		СсылкаНаФайлФаксимилеВИБ = ПолучитьНавигационнуюСсылку(ПолучитьКлючЗаписиНаСервере(), "Факсимиле");
		ПолучитьФайл(СсылкаНаФайлФаксимилеВИБ, ИмяФайла);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УдалитьФаксимиле(Команда)
	Если ЭтоАдресВременногоХранилища(СсылкаНаФайлФаксимиле) Тогда
		УдалитьИзВременногоХранилища(СсылкаНаФайлФаксимиле);
		СсылкаНаФайлФаксимиле = ПолучитьНавигационнуюСсылку(ПолучитьКлючЗаписиНаСервере(), "Факсимиле");
		ИмяФайлаФаксимиле = "";
	ИначеЕсли Не ПустаяСтрока(СсылкаНаФайлФаксимиле) Тогда
		УдалитьФаксимилеНаСервере();
		СсылкаНаФайлФаксимиле = "";//ПолучитьНавигационнуюСсылку(РегистрыСведений.скEDI_Факсимиле.СоздатьКлючЗаписи(Новый Структура("Подпись", Объект.Ссылка)), "Факсимиле");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПолучитьКлючЗаписиНаСервере()
	Возврат РегистрыСведений.скEDI_Факсимиле.СоздатьКлючЗаписи(Новый Структура("Подпись", Объект.Ссылка));	
КонецФункции

&НаКлиенте
Процедура ГруппыПодписиПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура СертификатыИспользоватьПриИзменении(Элемент)
	СертификатыТекущиеДанные = Элементы.Сертификаты.ТекущиеДанные;
	Если СертификатыТекущиеДанные <> Неопределено Тогда
		Если СертификатыТекущиеДанные.Использовать = Истина Тогда
			Для Каждого Строка Из Объект.Сертификаты Цикл
				Если Строка <> СертификатыТекущиеДанные Тогда
					Строка.Использовать = Ложь;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	ЗаполнитьГруппыПодписиСервере();
	ЗаполнитьТаблицуПользователейСервере();
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПользователейЕстьДоступПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаСервере
Процедура ОбновитьЗначениеНастройкиПользователяТолькоДоступныеПодписиСервере(Пользователь)
	Если ЗначениеЗаполнено(Пользователь) Тогда
		МассивОтобраныхСтрок = ТаблицаПользователей.НайтиСтроки(Новый Структура("Пользователь", Пользователь));
	Иначе
		МассивОтобраныхСтрок = ТаблицаПользователей;
	КонецЕсли;
	Для Каждого ЭлементМассиваОтобраныхСтрок из МассивОтобраныхСтрок Цикл
		ЭлементМассиваОтобраныхСтрок.Контроль = ПланыВидовХарактеристик.скEDI_НастройкиПользователей.ПолучитьЗначениеНастройки(ЭлементМассиваОтобраныхСтрок.Пользователь, ПредопределенноеЗначение("ПланВидовХарактеристик.скEDI_НастройкиПользователей.ТолькоДоступныеПодписи"));
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если Источник <> ЭтаФорма Тогда
		Если ИмяСобытия = "скEDI_ИзмененоЗначениеНастройкиПользователя_ТолькоДоступныеПодписи" Тогда
			ОбновитьЗначениеНастройкиПользователяТолькоДоступныеПодписиСервере(Параметр);
		ИначеЕсли ИмяСобытия = "скEDI_ИзмененоЗначениеНастройкиВхожденияПодписиВГруппу" Тогда
			Если ТипЗнч(Параметр) = Тип("ФиксированнаяСтруктура") Тогда
				ПодписьПоОповещению = Неопределено;
				Если Параметр.Свойство("Подпись", ПодписьПоОповещению) Тогда
					Если ПодписьПоОповещению = Объект.Ссылка Тогда
						ЗаполнитьГруппыПодписиСервере();
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		ИначеЕсли ИмяСобытия = "скEDI_ИзмененоЭлементСправочникаПодписи" Тогда
			Если ТипЗнч(Параметр) = Тип("ФиксированнаяСтруктура") Тогда
				ПодписьПоОповещению = Неопределено;
				Если Параметр.Свойство("Подпись", ПодписьПоОповещению) Тогда
					Если ПодписьПоОповещению = Объект.Ссылка Тогда
						Если не Модифицированность Тогда
							Прочитать();
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	ПараметрОповещения = Новый ФиксированнаяСтруктура(Новый Структура("Подпись, Организация", Объект.Ссылка, Объект.Владелец));
	Оповестить("скEDI_ИзмененоЭлементСправочникаПодписи", ПараметрОповещения, ЭтаФорма);
	Для Каждого ЭлементГруппыПодписиИзмененоВхождение из ГруппыПодписиИзмененоВхождение Цикл
		ПараметрОповещения = Новый ФиксированнаяСтруктура(Новый Структура("ГруппаПодписи, Подпись, Организация", ЭлементГруппыПодписиИзмененоВхождение.Значение, Объект.Ссылка, Объект.Владелец));
		Оповестить("скEDI_ИзмененоЗначениеНастройкиВхожденияПодписиВГруппу", ПараметрОповещения, ЭтаФорма);
	КонецЦикла;
	ГруппыПодписиИзмененоВхождение.Очистить();
КонецПроцедуры

&НаКлиенте
Процедура ГруппыПодписиВходитВГруппуОтметитьВсе(Команда)
	Для Каждого ТекущиеДанные Из ГруппыПодписи Цикл
		Если не ТекущиеДанные.ВходитВГруппу Тогда
			ТекущиеДанные.ВходитВГруппу = Истина;
			Модифицированность = Истина;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ГруппыПодписиВходитВГруппуСнятьВсеОтметки(Команда)
	Для Каждого ТекущиеДанные Из ГруппыПодписи Цикл
		Если ТекущиеДанные.ВходитВГруппу Тогда
			ТекущиеДанные.ВходитВГруппу = Ложь;
			Модифицированность = Истина;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПользователейЕстьДоступОтметитьВсе(Команда)
	Для Каждого ТекущиеДанные Из ТаблицаПользователей Цикл
		Если не ТекущиеДанные.ЕстьДоступ Тогда
			ТекущиеДанные.ЕстьДоступ = Истина;
			Модифицированность = Истина;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПользователейЕстьДоступСнятьВсеОтметки(Команда)
	Для Каждого ТекущиеДанные Из ТаблицаПользователей Цикл
		Если ТекущиеДанные.ЕстьДоступ Тогда
			ТекущиеДанные.ЕстьДоступ = Ложь;
			Модифицированность = Истина;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

