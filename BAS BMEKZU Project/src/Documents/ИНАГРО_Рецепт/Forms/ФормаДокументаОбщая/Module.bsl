#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды 
	
	Если Параметры.Ключ.Пустая() Тогда
		ПодготовитьФормуНаСервере();		
	КонецЕсли;
	
	// Уведомим о появлении функционала рабочей даты
	ЭтаФорма.НастройкиПредупреждений = ОбщегоНазначенияБП.НастройкиПредупрежденийОбИзменениях("РабочаяДатаИзДокумента");
	 
	// Показываем, если это новый документ и сама рабочая дата еще не установлена.
	ЭтаФорма.НастройкиПредупреждений.РабочаяДатаИзДокумента = ЭтаФорма.НастройкиПредупреждений.РабочаяДатаИзДокумента
	 	И ЭтаФорма.Параметры.Ключ.Пустая()
	  	И НЕ ЗначениеЗаполнено(БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("РабочаяДата"));
		
	УстановитьПараметрыВыбораВидОперации();
	
	// Если форма вызвана в режиме смена вида операции - модифицируем сразу при открытии, 
	// чтобы можно было подтвердить или отказаться от изменения путем сохранения или 
	// отказа от сохранения документа.
	Если Параметры.Свойство("ИзменитьВидОперации")
		И Параметры.ИзменитьВидОперации Тогда
		
		// Не кэшируем переменную Объект, т.к. может вызываться Форма.ИзменитьРеквизиты(),
		// которая меняет Объект.
		Объект.ВидОперации = Параметры.ЗначенияЗаполнения.ВидОперации;
		
		УстановитьЗаголовокФормы();		
		УправлениеФормой(ЭтаФорма);
		
		Модифицированность = Истина;
		
	КонецЕсли;	
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов 	

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	ОбщегоНазначенияБПКлиент.ОбработкаОповещенияФормыДокумента(ЭтаФорма, Объект.Ссылка, ИмяСобытия, Параметр, Источник);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ПодготовитьФормуНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	УстановитьЗаголовокФормы();

	УстановитьСостояниеДокумента();
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	Если НачалоДня(Объект.Дата) = НачалоДня(ТекущаяДатаДокумента) Тогда
		// Изменение времени не влияет на поведение документа.
		ТекущаяДатаДокумента = Объект.Дата;
		Возврат;
	КонецЕсли;
	
	// Общие проверки условий по датам.
	ТребуетсяВызовСервера = ИНАГРО_ЭлеваторКлиент.ТребуетсяВызовСервераПриИзмененииДатыДокумента(Объект.Дата, ТекущаяДатаДокумента);

	// Если определили, что изменение даты может повлиять на какие-либо параметры, 
	// то передаем обработку на сервер.
	Если ТребуетсяВызовСервера Тогда
		ДатаПриИзмененииНаСервере();
	КонецЕсли;
		
	// Запомним новую дату документа.
	ТекущаяДатаДокумента = Объект.Дата;
	
КонецПроцедуры

&НаСервере
Процедура ДатаПриИзмененииНаСервере()
	
	УстановитьФункциональныеОпцииФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ВидОперацииПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.ВидОперации) Тогда			
		
		Если Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ИНАГРО_ВидыОперацийРецепт.РецептПоОднойГотовойПродукции") Тогда
			
			Если Объект.СписокПродукции.Количество() > 1 Тогда
				Оповещение = Новый ОписаниеОповещения("ВидОперацииПриИзмененииЗавершение", ЭтотОбъект);
				ТекстВопроса = НСтр("ru='Все строки таблицы ""Продукция"", кроме первой, будут удалены! Продолжить?';uk='Всі рядки таблиці ""Прокукція"" будуть видалені! Продовжити?'");
				ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
				Возврат;
			ИначеЕсли Объект.СписокПродукции.Количество() = 1 Тогда 	
				Объект.Продукция = Объект.СписокПродукции[0].Номенклатура;
				Объект.СписокПродукции[0].Процент = 100;
			КонецЕсли;
			
		КонецЕсли;	

		ВидОперацииПриИзмененииНаСервере();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидОперацииПриИзмененииЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ИНАГРО_ВидыОперацийРецепт.РецептПоНесколькимГотовымПродукциям");
		ВидОперацииПриИзмененииНаСервере();
		Возврат;
	КонецЕсли; 	
	
	Пока Объект.СписокПродукции.Количество() > 1 Цикл
		СтрокаУдаления = Объект.СписокПродукции[1];
		Объект.СписокПродукции.Удалить(СтрокаУдаления);
	КонецЦикла;
	
	Объект.Продукция = Объект.СписокПродукции[0].Номенклатура;
	Объект.СписокПродукции[0].Процент = 100;
	
	ВидОперацииПриИзмененииНаСервере();

КонецПроцедуры

&НаСервере
Процедура ВидОперацииПриИзмененииНаСервере()
	
	УстановитьЗаголовокФормы();
	
	УправлениеФормой(ЭтаФорма);
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)

	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		ОрганизацияПриИзмененииНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	УстановитьФункциональныеОпцииФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПродукцияПриИзменении(Элемент)
	
	Объект.СписокПродукции.Очистить();
	
	НоваяСтрока = Объект.СписокПродукции.Добавить();
	НоваяСтрока.Номенклатура = Объект.Продукция;
	НоваяСтрока.Процент      = 100;
	
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеДвиженияФормы36НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования,
		ЭтотОбъект,
		"Объект.ОписаниеДвиженияФормы36",
		НСтр("ru='Описание движения формы 36';uk='Опис руху форми 36'"));

КонецПроцедуры
	
&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования,
		ЭтотОбъект,
		"Объект.Комментарий");

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокПродукции

&НаКлиенте
Процедура СписокПродукцииПередУдалением(Элемент, Отказ)
	
	Если Объект.СписокПродукции.Количество() = 1 Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьПериод(Команда)

	ПараметрыФормыВыбора = Новый Структура("НачалоПериода, КонецПериода", Объект.ДатаВывозаС, Объект.ДатаВывозаПо);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериода", ПараметрыФормыВыбора, Элементы.ВыбратьПериод, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериодЗавершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Объект.ДатаВывозаС	= РезультатВыбора.НачалоПериода;
	Объект.ДатаВывозаПо = РезультатВыбора.КонецПериода;		
		
КонецПроцедуры

&НаКлиенте
Процедура Рассчитать(Команда)
	
	// расчет для сырья
	Для Каждого СтрокаТабличнойЧасти Из Объект.СписокНоменклатуры Цикл
		СтрокаТабличнойЧасти.Количество       = Окр((Объект.ВесПорции * СтрокаТабличнойЧасти.Процент / 100), 0);
		СтрокаТабличнойЧасти.КоличествоПартии = Окр((Объект.ВесПартии * СтрокаТабличнойЧасти.Процент / 100), 0);
	КонецЦикла;
	
	// расчет для готовой продукции
	Если Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ИНАГРО_ВидыОперацийРецепт.РецептПоНесколькимГотовымПродукциям") Тогда
		Для Каждого СтрокаТабличнойЧасти Из Объект.СписокПродукции Цикл
			СтрокаТабличнойЧасти.Количество       = Окр(Объект.ВесПорции * СтрокаТабличнойЧасти.Процент / 100, 0);
			СтрокаТабличнойЧасти.КоличествоПартии = Окр(Объект.ВесПартии * СтрокаТабличнойЧасти.Процент / 100, 0);	
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции 

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	ТекущаяДатаДокумента = Объект.Дата;
	
	УстановитьФункциональныеОпцииФормы();
	
	УстановитьЗаголовокФормы();
	
	УправлениеФормой(ЭтаФорма);
	
	УстановитьСостояниеДокумента();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()
	
	ОбщегоНазначенияБПКлиентСервер.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтаФорма);
	
КонецПроцедуры 

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)

	Элементы = Форма.Элементы;
	Объект   = Форма.Объект;	
	
	Если Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ИНАГРО_ВидыОперацийРецепт.РецептПоОднойГотовойПродукции") Тогда
		Элементы.Продукция.Видимость = Истина;
		Элементы.Страницы.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;		
		Элементы.СписокПродукции.Видимость   = Ложь;
		Элементы.ГруппаПродукция.Заголовок   = НСтр("ru='Продукция, вес';uk='Продукція, вага'");
		Элементы.СписокНоменклатуры.ПодчиненныеЭлементы.СписокНоменклатурыНоменклатура.Заголовок = НСтр("ru='Сырье';uk='Сировина'")
	Иначе	  								
		Элементы.Продукция.Видимость = Ложь;
		Элементы.Страницы.ОтображениеСтраниц = ОтображениеСтраницФормы.ЗакладкиСверху;
		Элементы.СписокПродукции.Видимость   = Истина;
		Элементы.ГруппаПродукция.Заголовок   = НСтр("ru='Вес';uk='Вага'");
		Элементы.СписокНоменклатуры.ПодчиненныеЭлементы.СписокНоменклатурыНоменклатура.Заголовок = НСтр("ru='Номенклатура';uk='Номенклатура'")
	КонецЕсли;	
				
КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрыВыбораВидОперации()
	
	МассивВидовОпераций = Документы.ИНАГРО_Рецепт.ПолучитьФиксированныйМассивВидовОпераций();
	
	ПараметрМассивВидовОпераций = Новый ПараметрВыбора("Отбор.Ссылка", МассивВидовОпераций);
	
	НовыйМассив = Новый Массив();
	НовыйМассив.Добавить(ПараметрМассивВидовОпераций);
	НовыеПараметры = Новый ФиксированныйМассив(НовыйМассив);
	
	Элементы.ВидОперации.ПараметрыВыбора = НовыеПараметры;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовокФормы()
	
	ОбъектФормы = ЭтаФорма.Объект;

	ТекстЗаголовка = НСтр("ru='Рецепт';uk='Рецепт'");
	
	Если ЗначениеЗаполнено(ОбъектФормы.Ссылка) Тогда
		ТекстЗаголовка = ТекстЗаголовка + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru=' %1 от %2';uk=' %1 від %2'"), ОбъектФормы.Номер, ОбъектФормы.Дата);
	Иначе
		ТекстЗаголовка = ТекстЗаголовка + НСтр("ru=' (создание)';uk=' (створення)'");
	КонецЕсли;
	
	ЭтаФорма.Заголовок = ТекстЗаголовка + " (" + Строка(ОбъектФормы.ВидОперации) + ")";

КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	СостояниеДокумента = ОбщегоНазначенияБП.СостояниеДокумента(Объект);	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункцииБСП

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти
