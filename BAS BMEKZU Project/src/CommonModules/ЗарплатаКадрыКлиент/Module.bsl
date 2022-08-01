////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС



////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

Процедура ОбработатьВыводПоляАдреса(Элемент, ПредставлениеАдреса, Адрес) Экспорт
	
	МассивОшибок = ЗарплатаКадрыВызовСервера.ПроверитьАдрес(Адрес);
	СообщениеПроверки = "";
	Если НЕ ПустаяСтрока(Адрес) И МассивОшибок.Количество() <> 0  Тогда
		Для каждого СтруктураОшибки Из МассивОшибок Цикл
			СообщениеПроверки = СообщениеПроверки + СтруктураОшибки.Сообщение + Символы.ПС;
		КонецЦикла;
		СтроковыеФункцииКлиентСервер.УдалитьПоследнийСимволВСтроке(СообщениеПроверки, 1);
		Элемент.Подсказка = СообщениеПроверки;
		Элемент.ЦветТекста = ОбщегоНазначенияКлиент.ЦветСтиля("ПоясняющийОшибкуТекст");
		Элемент.Гиперссылка = Истина;
	Иначе
		Элемент.Подсказка = СообщениеПроверки;
		Элемент.ЦветТекста = ОбщегоНазначенияКлиент.ЦветСтиля("ЦветТекстаФормы");
		Элемент.Гиперссылка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

// Проверяет заполнение реквизита "Организация" у переданного объекта
// 
// Параметры
//	ПроверяемыйОбъект	- проверяемое, любой объект, допускающий доступ к полям по имени
//	                      и имеющий свойство Организация
//								
//	Возвращаемое значение:
//		Булево. Истина - организация заполнена, Ложь - в противном случае. 
//			
Функция ОрганизацияЗаполнена(ПроверяемыйОбъект) Экспорт
	
	ПравилаПроверки = Новый Структура("Организация");
	
	ОрганизацияЗаполнена =  ЗарплатаКадрыКлиентСервер.СвойстваЗаполнены(ПроверяемыйОбъект, ПравилаПроверки, Ложь);

	Если НЕ ОрганизацияЗаполнена Тогда
	     ПоказатьПредупреждение(,НСтр("ru='Для заполнения документа необходимо выбрать организацию!';uk='Для заповнення документа необхідно вибрати організацію!'"),,"Ошибка заполнения");
	 КонецЕсли;
	 Возврат ОрганизацияЗаполнена
КонецФункции

// Обработчики событий поля ввода

Процедура ВводМесяцаПриИзменении(РедактируемыйОбъект, ПутьРеквизита, ПутьРеквизитаПредставления, Модифицированность = Ложь) Экспорт
	
	ЗначениеПредставления = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(РедактируемыйОбъект, ПутьРеквизитаПредставления);
	Значение              = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(РедактируемыйОбъект, ПутьРеквизита);
	
	ДатаКакМесяцПодобратьДатуПоТексту(ЗначениеПредставления, Значение);
	
	ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(РедактируемыйОбъект, ПутьРеквизитаПредставления, ЗарплатаКадрыКлиентСервер.ПолучитьПредставлениеМесяца(Значение));
	ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(РедактируемыйОбъект, ПутьРеквизита, Значение);
	
	Модифицированность = Истина;
	
КонецПроцедуры 

Процедура ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка) Экспорт
	
	ДанныеВыбора = ДатаКакМесяцПодобратьДатуПоТексту(Текст);
	
	Если ДанныеВыбора.Количество() = 1 Тогда
		ТекстАвтоПодбора = ДанныеВыбора[0].Значение;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

Процедура ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка) Экспорт
	
	Если Текст <> "" Тогда
		ДанныеВыбора = ДатаКакМесяцПодобратьДатуПоТексту(Текст);
		Если ДанныеВыбора.Количество() = 1 Тогда
			Значение = Текст;
		Иначе
			Значение = ДанныеВыбора;
		КонецЕсли;
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура ВводМесяцаНачалоВыбора(Форма, РедактируемыйОбъект, ПутьРеквизита, ПутьРеквизитаПредставления, ИзменитьМодифицированность = Истина, ОповещениеЗавершения = Неопределено) Экспорт
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма", Форма);
	ДополнительныеПараметры.Вставить("РедактируемыйОбъект", РедактируемыйОбъект);
	ДополнительныеПараметры.Вставить("ПутьРеквизита", ПутьРеквизита);
	ДополнительныеПараметры.Вставить("ПутьРеквизитаПредставления", ПутьРеквизитаПредставления);
	ДополнительныеПараметры.Вставить("ИзменитьМодифицированность", ИзменитьМодифицированность);
	ДополнительныеПараметры.Вставить("ОповещениеЗавершения", ОповещениеЗавершения);
	
	Значение = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(РедактируемыйОбъект, ПутьРеквизита);
	
	Оповещение = Новый ОписаниеОповещения("ВводМесяцаНачалоВыбораЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ОткрытьФорму("ОбщаяФорма.ВыборПериода", 
		Новый Структура("Значение,РежимВыбораПериода,ЗапрашиватьРежимВыбораПериодаУВладельца", Значение, "Месяц", Ложь),
		Форма, , , , Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

Процедура ВводМесяцаНачалоВыбораЗавершение(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт

	Форма = ДополнительныеПараметры.Форма;
	РедактируемыйОбъект = ДополнительныеПараметры.РедактируемыйОбъект;
	ПутьРеквизита = ДополнительныеПараметры.ПутьРеквизита;
	ПутьРеквизитаПредставления = ДополнительныеПараметры.ПутьРеквизитаПредставления;
	ИзменитьМодифицированность = ДополнительныеПараметры.ИзменитьМодифицированность;
	ОповещениеЗавершения = ДополнительныеПараметры.ОповещениеЗавершения;
	
	Если ВыбранноеЗначение = Неопределено Тогда
		
		Если ОповещениеЗавершения <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ОповещениеЗавершения, Ложь);
		КонецЕсли;
		
	Иначе
		
		Значение = ВыбранноеЗначение;
		
		ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(РедактируемыйОбъект, ПутьРеквизита, Значение);
		Представление = ЗарплатаКадрыКлиентСервер.ПолучитьПредставлениеМесяца(Значение);
		ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(РедактируемыйОбъект, ПутьРеквизитаПредставления, Представление);
		
		Если ИзменитьМодифицированность Тогда 
			Форма.Модифицированность = Истина;
		КонецЕсли;
		
		Если ОповещениеЗавершения <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ОповещениеЗавершения, Истина);
		КонецЕсли;
		
	КонецЕсли;
	
	Если ОповещениеЗавершения = Неопределено Тогда
		Форма.ОбновитьОтображениеДанных();
	КонецЕсли;
	
КонецПроцедуры

Процедура ВводМесяцаРегулирование(РедактируемыйОбъект, ПутьРеквизита, ПутьРеквизитаПредставления, Направление, Модифицированность = Ложь) Экспорт
	
	Значение = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(РедактируемыйОбъект, ПутьРеквизита);
	Значение = ДобавитьМесяц(Значение, Направление);
	
	ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(РедактируемыйОбъект, ПутьРеквизита, Значение);
	ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(РедактируемыйОбъект, ПутьРеквизитаПредставления, ЗарплатаКадрыКлиентСервер.ПолучитьПредставлениеМесяца(Значение));
	
	Модифицированность = Истина;
 	
КонецПроцедуры 

////////////////////////////////////////////////////////////////////////////////

// Обработчик события, связанного с редактированием места рождения
// Событие НачалоВыбора в поля место рождения в таблице
Процедура МестоРожденияВТаблицеНачалоВыбора(МестоРождения, МестоРожденияПредставление, ОповещениеЗавершения = Неопределено) Экспорт	
	
	ДополнительныеПараметры = Новый Структура("ОповещениеЗавершения", ОповещениеЗавершения);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Представление", МестоРождения);
	
	Оповещение = Новый ОписаниеОповещения("МестоРожденияВТаблицеНачалоВыбораЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ОткрытьФорму("ОбщаяФорма.ВводМестаРождения", ПараметрыФормы, , , , , Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
КонецПроцедуры

Процедура МестоРожденияВТаблицеНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ДанныеМестаРождения = Неопределено;
	
	Если Результат <> Неопределено Тогда
		ДанныеМестаРождения = Новый Структура;
		ДанныеМестаРождения.Вставить("МестоРождения", Результат);
		ДанныеМестаРождения.Вставить("МестоРожденияПредставление", КадровыйУчетКлиентСервер.ПредставлениеМестаРождения(Результат));
	КонецЕсли;	
	
	Если ДополнительныеПараметры.ОповещениеЗавершения <> Неопределено Тогда 
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеЗавершения, ДанныеМестаРождения);
	КонецЕсли;
	
КонецПроцедуры

// Редактирование данных физического лица
Процедура ОткрытьФормуФизическогоЛицаДляРедактирования(ФизическоеЛицо, ИмяЭлемента) Экспорт 
	СтруктураСоответствияПолей = ПолучитьСоответствиеПолейФормыДокументаПолямФормыФизическогоЛица();
	Параметры = Новый Структура("Ключ, ТекущийЭлемент", ФизическоеЛицо, СтруктураСоответствияПолей[ИмяЭлемента]);
	
	ОткрытьФорму("Справочник.ФизическиеЛица.ФормаОбъекта", Параметры);
КонецПроцедуры	

// Получение идентифицируемого объекта
Функция СсылкаНаОбъектПоИдентификатору(ПолноеИмяОбъекта, ИдентификаторОбъекта) Экспорт
	Возврат ЗарплатаКадрыКлиентПовтИсп.СсылкаНаОбъектПоИдентификатору(ПолноеИмяОбъекта, ИдентификаторОбъекта);
КонецФункции	

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ


Функция ПолучитьСоответствиеПолейФормыДокументаПолямФормыФизическогоЛица()
	СтруктураСоответствия = Новый Структура();
	СтруктураСоответствия.Вставить("Фамилия", "Наименование");
	СтруктураСоответствия.Вставить("Имя", "Наименование");
	СтруктураСоответствия.Вставить("Отчество", "Наименование");
	СтруктураСоответствия.Вставить("Пол", "ФизлицоПол");
	СтруктураСоответствия.Вставить("ДатаРождения", "ФизлицоДатаРождения");
	СтруктураСоответствия.Вставить("МестоРожденияПредставление", "ФизическоеЛицоМестоРождения");
	СтруктураСоответствия.Вставить("Гражданство", "ГражданствоФизическихЛицСтрана");
	СтруктураСоответствия.Вставить("АдресФактическийПредставление", "ГруппаКонтактнаяИнформация");
	СтруктураСоответствия.Вставить("АдресРегистрацииПредставление", "ГруппаКонтактнаяИнформация");
	СтруктураСоответствия.Вставить("Телефоны", "ГруппаКонтактнаяИнформация");	
	СтруктураСоответствия.Вставить("ДокументУдостверяющийЛичность", "ДокументыФизическихЛицВидДокумента"); 

	Возврат СтруктураСоответствия;
	
КонецФункции	

////////////////////////////////////////////////////////////////////////////////
// Универсальный механизм "Месяц строкой"

// подбирает массив номеров месяцев, соответствующих переданной строке
// например, для строки "ма" это будут 3 и 5, для "а" - 4 и 8
// используется в ПодобратьДатуПоТексту
//
Функция СписокМесяцевПоСтроке(Текст)
	
	СписокМесяцев  = Новый СписокЗначений;
	Месяцы         = Новый Соответствие;
	МесяцыВозврата = Новый Массив;
	
	Для Счетчик = 1 По 12 Цикл
		Представление = Формат(Дата(2000, Счетчик, 1), "ДФ='ММММ'");
		СписокМесяцев.Добавить(Счетчик, Представление);
		Представление = Формат(Дата(2000, Счетчик, 1), "ДФ='МММ'");
		СписокМесяцев.Добавить(Счетчик, Представление);
	КонецЦикла;
	
	Для Каждого ЭлементСписка Из СписокМесяцев Цикл
		Если ВРег(Текст) = ВРег(Лев(ЭлементСписка.Представление, СтрДлина(Текст))) Тогда
			Месяцы[ЭлементСписка.Значение] = 0;
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого Элемент Из Месяцы Цикл
		МесяцыВозврата.Добавить(Элемент.Ключ);
	КонецЦикла;
	
	Возврат МесяцыВозврата;
	
КонецФункции

Функция ДатаКакМесяцПодобратьДатуПоТексту(Текст, ДатаПоТексту = НеОпределено)
	
	СписокВозврата = Новый СписокЗначений;
	ТекущийГод = Год(ЗарплатаКадрыКлиентСервер.ДатаСеанса());
	
	Если ПустаяСтрока(Текст) Тогда
		ДатаПоТексту = Дата(1, 1, 1);
		СписокВозврата.Добавить("");
		Возврат СписокВозврата;
	КонецЕсли;
	
	Если Найти(Текст, ".") <> 0 Тогда
		Подстроки = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Текст, ".");
	ИначеЕсли Найти(Текст, ",") <> 0 Тогда
		Подстроки = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Текст, ",");
	ИначеЕсли Найти(Текст, "-") <> 0 Тогда
		Подстроки = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Текст, "-");
	ИначеЕсли Найти(Текст, "/") <> 0 Тогда
		Подстроки = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Текст, "/");
	ИначеЕсли Найти(Текст, "\") <> 0 Тогда
		Подстроки = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Текст, "\");
	Иначе
		Подстроки = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Текст, " ");
	КонецЕсли;
	
	Если Подстроки.Количество() = 1 Тогда
		
		Если СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Текст) Тогда
			МесяцЧислом = Число(Текст);
			Если МесяцЧислом >= 1 и МесяцЧислом <=12 Тогда
				ДатаПоТексту = Дата(ТекущийГод, МесяцЧислом, 1);
				Если СтрДлина(Текст) = 1 Тогда
					СписокВозврата.Добавить(Формат(ДатаПоТексту, "ДФ='М/гг'"));
				Иначе
					СписокВозврата.Добавить(Формат(ДатаПоТексту, "ДФ='ММ/гг'"));
				КонецЕсли;
			Иначе
				Возврат СписокВозврата;
			КонецЕсли;                
		Иначе
			СписокМесяцев = СписокМесяцевПоСтроке(Текст);
			Для Каждого Месяц Из СписокМесяцев Цикл
				ДатаПоТексту = Дата(ТекущийГод, Месяц, 1);
				СписокВозврата.Добавить(Формат(ДатаПоТексту, "ДФ='ММММ гггг'"));
			КонецЦикла;
		КонецЕсли;
		
	ИначеЕсли Подстроки.Количество() = 2 Тогда
		
		Если СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Подстроки[1]) Тогда
			
			Если ПустаяСтрока(Подстроки[1]) Тогда
				ГодЧислом = 0;
				Подстроки[1] = "0";
				ТекстВозврата = Текст + "0";
			Иначе
				ГодЧислом = Число(Подстроки[1]);
				ТекстВозврата = "";
			КонецЕсли;
			
			Если ГодЧислом > 3000 Тогда
				Возврат СписокВозврата;
			КонецЕсли;
			
			Если СтрДлина(Подстроки[1]) <= 1 Тогда
				ГодЧислом = Число(Лев(Формат(ТекущийГод, "ЧГ="), 3) + Подстроки[1]);
			ИначеЕсли СтрДлина(Подстроки[1]) = 2 Тогда
				ГодЧислом = Число(Лев(Формат(ТекущийГод, "ЧГ="), 2) + Подстроки[1]);
			ИначеЕсли СтрДлина(Подстроки[1]) = 3 Тогда
				ГодЧислом = Число(Лев(Формат(ТекущийГод, "ЧГ="), 1) + Подстроки[1]);
			ИначеЕсли СтрДлина(Подстроки[1]) = 4 Тогда
				ГодЧислом = Число(Подстроки[1]);
			КонецЕсли;                    
			
		Иначе
			
			Возврат СписокВозврата;
			
		КонецЕсли;                
		Если ЗначениеЗаполнено(Подстроки[0]) И СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Подстроки[0]) Тогда
			
			МесяцЧислом = Число(Подстроки[0]);
			Если МесяцЧислом >= 1 и МесяцЧислом <= 12 Тогда
				ДатаПоТексту = Дата(ГодЧислом, МесяцЧислом, 1);
				СписокВозврата.Добавить(Формат(ДатаПоТексту, "ДФ='ММММ гггг'"));
			Иначе
				Возврат СписокВозврата;
			КонецЕсли;                
			
		Иначе
			
			СписокМесяцев = СписокМесяцевПоСтроке(Подстроки[0]);
			
			Если СписокМесяцев.Количество() = 1 Тогда
				ДатаПоТексту = Дата(ГодЧислом, СписокМесяцев[0], 1);
				СписокВозврата.Добавить(Формат(ДатаПоТексту, "ДФ='ММММ гггг'"));
			Иначе
				Для Каждого Месяц Из СписокМесяцев Цикл
					ДатаПоТексту = Дата(ГодЧислом, Месяц, 1);
					СписокВозврата.Добавить(Формат(Дата(ГодЧислом, Месяц, 1), "ДФ='ММММ гггг'"));
				КонецЦикла;
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
	Возврат СписокВозврата;
	
КонецФункции

