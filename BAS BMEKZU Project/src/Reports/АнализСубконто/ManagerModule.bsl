#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Возврат Новый Структура("ИспользоватьПередКомпоновкойМакета,
							|ИспользоватьПослеКомпоновкиМакета,
							|ИспользоватьПослеВыводаРезультата,
							|ИспользоватьДанныеРасшифровки",
							Истина, Истина, Истина, Истина);
							
КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	ИспользоватьКлассыСчетовВКачествеГрупп = БухгалтерскийУчетПереопределяемый.ПолучитьИспользоватьКлассыСчетовВКачествеГрупп();
	КоличествоУровнейСчет = ?(ИспользоватьКлассыСчетовВКачествеГрупп, 2, 1);
	
	КомпоновщикНастроек.Настройки.Структура.Очистить();
	КомпоновщикНастроек.Настройки.Выбор.Элементы.Очистить();
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "Периодичность", ПараметрыОтчета.Периодичность);
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.НачалоПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", НачалоДня(ПараметрыОтчета.НачалоПериода));
	КонецЕсли;
	Если ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", КонецДня(ПараметрыОтчета.КонецПериода));
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ПараметрПериод", КонецДня(ПараметрыОтчета.КонецПериода));
	Иначе
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ПараметрПериод", КонецДня(ТекущаяДата()));
	КонецЕсли;
	
	МассивВидовСубконто = Новый Массив;
	Для Каждого ЭлементСписка Из ПараметрыОтчета.СписокВидовСубконто Цикл
		Если ЗначениеЗаполнено(ЭлементСписка.Значение) Тогда 
			МассивВидовСубконто.Добавить(ЭлементСписка.Значение);
		КонецЕсли;
	КонецЦикла;
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "СписокВидовСубконто", МассивВидовСубконто);
	
	КоличествоПоказателей = БухгалтерскиеОтчетыВызовСервера.КоличествоПоказателей(ПараметрыОтчета);
	
	Если КоличествоПоказателей > 1 Тогда
		ГруппаПоказатели = КомпоновщикНастроек.Настройки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		ГруппаПоказатели.Заголовок     = НСтр("ru='Показатели';uk='Показники'");
		ГруппаПоказатели.Использование = Истина;
		ГруппаПоказатели.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
		
		Для Каждого ИмяПоказателя Из ПараметрыОтчета.НаборПоказателей Цикл
			Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда 
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаПоказатели, "Показатели." + ИмяПоказателя);
			КонецЕсли;
		КонецЦикла;	
	КонецЕсли;

	
	ГруппаСальдоНаНачало = КомпоновщикНастроек.Настройки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаСальдоНаНачало.Заголовок     = НСтр("ru='Сальдо на начало периода';uk='Сальдо на початок періоду'");
	ГруппаСальдоНаНачало.Использование = Истина;
	ГруппаСальдоНаНачалоДт = ГруппаСальдоНаНачало.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаСальдоНаНачалоДт.Заголовок     = НСтр("ru='Дебет';uk='Дебет'");
	ГруппаСальдоНаНачалоДт.Использование = Истина;
	ГруппаСальдоНаНачалоДт.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	ГруппаСальдоНаНачалоКт = ГруппаСальдоНаНачало.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаСальдоНаНачалоКт.Заголовок     = НСтр("ru='Кредит';uk='Кредит'");
	ГруппаСальдоНаНачалоКт.Использование = Истина;
	ГруппаСальдоНаНачалоКт.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	
	ГруппаОбороты = КомпоновщикНастроек.Настройки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаОбороты.Заголовок     = НСтр("ru='Обороты за период';uk='Обороти за період'");
	ГруппаОбороты.Использование = Истина;
	ГруппаОборотыДт = ГруппаОбороты.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаОборотыДт.Заголовок     = НСтр("ru='Дебет';uk='Дебет'");
	ГруппаОборотыДт.Использование = Истина;
	ГруппаОборотыДт.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	ГруппаОборотыКт = ГруппаОбороты.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаОборотыКт.Заголовок     = НСтр("ru='Кредит';uk='Кредит'");
	ГруппаОборотыКт.Использование = Истина;
	ГруппаОборотыКт.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	
	ГруппаСальдоНаКонец = КомпоновщикНастроек.Настройки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаСальдоНаКонец.Заголовок     = НСтр("ru='Сальдо на конец периода';uk='Сальдо на кінець періоду'");
	ГруппаСальдоНаКонец.Использование = Истина;
	ГруппаСальдоНаКонецДт = ГруппаСальдоНаКонец.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаСальдоНаКонецДт.Заголовок     = НСтр("ru='Дебет';uk='Дебет'");
	ГруппаСальдоНаКонецДт.Использование = Истина;
	ГруппаСальдоНаКонецДт.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	ГруппаСальдоНаКонецКт = ГруппаСальдоНаКонец.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаСальдоНаКонецКт.Заголовок     = НСтр("ru='Кредит';uk='Кредит'");
	ГруппаСальдоНаКонецКт.Использование = Истина;
	ГруппаСальдоНаКонецКт.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	
	Для Каждого ИмяПоказателя Из ПараметрыОтчета.НаборПоказателей Цикл
		Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда 
			ВидОстатка = ?(ПараметрыОтчета.РазвернутоеСальдо, "Развернутый", "");
			
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаСальдоНаНачалоДт, "СальдоНаНачалоПериода." + ИмяПоказателя + "Начальный" + ВидОстатка + "ОстатокДт");
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаСальдоНаНачалоКт, "СальдоНаНачалоПериода." + ИмяПоказателя + "Начальный" + ВидОстатка + "ОстатокКт");
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаОборотыДт,        "ОборотыЗаПериод."       + ИмяПоказателя + "ОборотДт");
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаОборотыКт,        "ОборотыЗаПериод."       + ИмяПоказателя + "ОборотКт");
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаСальдоНаКонецДт,  "СальдоНаКонецПериода."  + ИмяПоказателя + "Конечный"  + ВидОстатка + "ОстатокДт");
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаСальдоНаКонецКт,  "СальдоНаКонецПериода."  + ИмяПоказателя + "Конечный"  + ВидОстатка + "ОстатокКт");
		КонецЕсли;
	КонецЦикла;
	
	// Дополнительные данные
	БухгалтерскиеОтчетыВызовСервера.ДобавитьДополнительныеПоля(ПараметрыОтчета, КомпоновщикНастроек);
	
	УсловноеОформлениеАвтоотступа = Неопределено;
	Для каждого ЭлементОформления Из КомпоновщикНастроек.Настройки.УсловноеОформление.Элементы Цикл
		ЗначениеПараметраАвтоОтступа = ЭлементОформления.Оформление.Элементы.Найти("АвтоОтступ");
		Если ЗначениеПараметраАвтоОтступа <> Неопределено И ЗначениеПараметраАвтоОтступа.Использование Тогда	
			УсловноеОформлениеАвтоотступа = ЭлементОформления;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если УсловноеОформлениеАвтоотступа = Неопределено Тогда
		УсловноеОформлениеАвтоотступа = КомпоновщикНастроек.Настройки.УсловноеОформление.Элементы.Добавить();
		УсловноеОформлениеАвтоотступа.Представление = НСтр("ru='Уменьшенный автоотступ';uk='Зменшений автовідступ'");
		УсловноеОформлениеАвтоотступа.Оформление.УстановитьЗначениеПараметра("Автоотступ", 1);
		УсловноеОформлениеАвтоотступа.Использование = Ложь;
		УсловноеОформлениеАвтоотступа.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ;
	Иначе
		УсловноеОформлениеАвтоотступа.Поля.Элементы.Очистить();
	КонецЕсли;
	
	Структура = КомпоновщикНастроек.Настройки.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
	Первый = Истина;
	Для Каждого ПолеВыбраннойГруппировки Из ПараметрыОтчета.Группировка Цикл 
		Если ПолеВыбраннойГруппировки.Использование Тогда
			Если Не Первый Тогда 
				Структура = Структура.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
			КонецЕсли;
			Первый = Ложь;
			ПолеГруппировки = Структура.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
			ПолеГруппировки.Использование  = Истина;
			ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных(ПолеВыбраннойГруппировки.Поле);
			Если ПолеВыбраннойГруппировки.ТипГруппировки = 1 Тогда
				ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Иерархия;
			ИначеЕсли ПолеВыбраннойГруппировки.ТипГруппировки = 2 Тогда
				ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.ТолькоИерархия;
			Иначе
				ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Элементы;
			КонецЕсли;
			Структура.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
			Структура.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
			
			ПолеОформления = УсловноеОформлениеАвтоотступа.Поля.Элементы.Добавить();
			ПолеОформления.Поле = ПолеГруппировки.Поле;
		КонецЕсли;
	КонецЦикла;
	Структура = Структура.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
	ПолеГруппировки = Структура.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
	ПолеГруппировки.Использование  = Истина;
	ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных("Счет");
	ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Иерархия;
	Структура.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
	Структура.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));  
	
	ПолеОформления = УсловноеОформлениеАвтоотступа.Поля.Элементы.Добавить();
	ПолеОформления.Поле = ПолеГруппировки.Поле;
	
	Если Не ПараметрыОтчета.ПоСубсчетам Тогда
		ЗначениеОтбора = БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(Структура.Отбор, "SystemFields.LevelInGroup", КоличествоУровнейСчет, ВидСравненияКомпоновкиДанных.МеньшеИлиРавно);
		ЗначениеОтбора.Применение = ТипПримененияОтбораКомпоновкиДанных.Иерархия;
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(Структура, "ВыводитьОтбор", ТипВыводаТекстаКомпоновкиДанных.НеВыводить);
	КонецЕсли;
	
	// Период
	БухгалтерскиеОтчетыВызовСервера.ДобавитьГруппировкуПоПериоду(ПараметрыОтчета, Структура);
	
	Для каждого ЭлементГруппировки Из Структура.ПоляГруппировки.Элементы Цикл
		Если ЭлементГруппировки.Поле = Новый ПолеКомпоновкиДанных(?(ПараметрыОтчета.Периодичность = 2, "Регистратор", "Период")) Тогда
			Поле = УсловноеОформлениеАвтоотступа.Поля.Элементы.Добавить();
			Поле.Поле = ЭлементГруппировки.Поле;
		КонецЕсли;
	КонецЦикла;
	
	Если ПараметрыОтчета.ПоказательВалютнаяСумма Тогда 
		Структура = Структура.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
		ПолеГруппировки = Структура.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеГруппировки.Использование  = Истина;
		ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных("Валюта");
		ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Иерархия;
		Структура.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
		Структура.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных")); 
		
		ПолеОформления = УсловноеОформлениеАвтоотступа.Поля.Элементы.Добавить();
		ПолеОформления.Поле = ПолеГруппировки.Поле;
	КонецЕсли;
	
	БухгалтерскиеОтчетыВызовСервера.ДобавитьОтборПоОрганизации(ПараметрыОтчета, КомпоновщикНастроек);
	БухгалтерскиеОтчетыВызовСервера.ДобавитьОтборДляПоказателяРазница(ПараметрыОтчета, КомпоновщикНастроек);
	
	Если УсловноеОформлениеАвтоотступа.Поля.Элементы.Количество() = 0 Тогда
		УсловноеОформлениеАвтоотступа.Использование = Ложь;
	КонецЕсли;
	
	// Пометить строки для удаления по счетам, на которых не ведется налоговый учет
	МассивПоказателей = Новый Массив;
	МассивПоказателей.Добавить("НУ");
	МассивПоказателей.Добавить("Разница");
	
	УсловноеОформление = КомпоновщикНастроек.Настройки.УсловноеОформление.Элементы.Добавить();
	Для Каждого Показатель Из МассивПоказателей Цикл
		Поле = УсловноеОформление.Поля.Элементы.Добавить();
		Поле.Поле = Новый ПолеКомпоновкиДанных("СальдоНаНачалоПериода." + Показатель + "НачальныйОстатокДт");
		Поле = УсловноеОформление.Поля.Элементы.Добавить();
		Поле.Поле = Новый ПолеКомпоновкиДанных("СальдоНаНачалоПериода." + Показатель + "НачальныйРазвернутыйОстатокДт");
		Поле = УсловноеОформление.Поля.Элементы.Добавить();
		Поле.Поле = Новый ПолеКомпоновкиДанных("СальдоНаКонецПериода." + Показатель + "КонечныйОстатокДт");
		Поле = УсловноеОформление.Поля.Элементы.Добавить();
		Поле.Поле = Новый ПолеКомпоновкиДанных("СальдоНаКонецПериода." + Показатель + "КонечныйРазвернутыйОстатокДт");
	КонецЦикла;
	
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(УсловноеОформление.Отбор, "Счет.НалоговыйУчет", Ложь);
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(УсловноеОформление.Оформление, "МаксимальнаяВысота", 1);
	
КонецПроцедуры

Процедура ПослеКомпоновкиМакета(ПараметрыОтчета, МакетКомпоновки) Экспорт
	
	МакетШапкиОтчета = БухгалтерскиеОтчетыВызовСервера.ПолучитьМакетШапки(МакетКомпоновки);
	
	КоличествоПоказателей = БухгалтерскиеОтчетыВызовСервера.КоличествоПоказателей(ПараметрыОтчета);
	
	КоличествоГруппировок = 1;
	Для Каждого СтрокаТаблицы Из ПараметрыОтчета.Группировка Цикл
		Если СтрокаТаблицы.Использование Тогда
			КоличествоГруппировок = КоличествоГруппировок + 1;
		КонецЕсли;
	КонецЦикла;
	
	КоличествоСтрокШапки = Макс(КоличествоГруппировок, 2);
	ПараметрыОтчета.Вставить("ВысотаШапки", КоличествоСтрокШапки);
	
	МассивДляУдаления = Новый Массив;
	Для Индекс = КоличествоСтрокШапки По МакетШапкиОтчета.Макет.Количество() - 1 Цикл
		МассивДляУдаления.Добавить(МакетШапкиОтчета.Макет[Индекс]);
	КонецЦикла;
	
	КоличествоСтрок = МакетШапкиОтчета.Макет.Количество();
	Для ИндексСтроки = 2 По КоличествоСтрок - 1 Цикл
		СтрокаМакета = МакетШапкиОтчета.Макет[ИндексСтроки];
		
		КоличествоКолонок = СтрокаМакета.Ячейки.Количество();
		
		Для ИндексКолонки = КоличествоКолонок - 6 По КоличествоКолонок - 1 Цикл
			Ячейка = СтрокаМакета.Ячейки[ИндексКолонки];
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(Ячейка.Оформление.Элементы, "ОбъединятьПоВертикали", Истина);
		КонецЦикла;
	КонецЦикла;
	
	Если КоличествоПоказателей > 1 Тогда
		Для ИндексСтроки = 1 По КоличествоСтрок - 1 Цикл
			СтрокаМакета = МакетШапкиОтчета.Макет[ИндексСтроки];
			
			КоличествоКолонок = СтрокаМакета.Ячейки.Количество();
			Ячейка = СтрокаМакета.Ячейки[КоличествоКолонок - 7];
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(Ячейка.Оформление.Элементы, "ОбъединятьПоВертикали", Истина);
		КонецЦикла;
	КонецЕсли;
	
	МакетПодвалаОтчета            = БухгалтерскиеОтчетыВызовСервера.ПолучитьМакетПодвала(МакетКомпоновки);
	МакетГруппировкиОрганизация   = БухгалтерскиеОтчетыВызовСервера.ПолучитьМакетГруппировкиПоПолюГруппировки(МакетКомпоновки, "Организация");
	МакетГруппировкиСчет          = БухгалтерскиеОтчетыВызовСервера.ПолучитьМакетГруппировкиПоПолюГруппировки(МакетКомпоновки, "Счет");
	МакетГруппировкиВалюта        = БухгалтерскиеОтчетыВызовСервера.ПолучитьМакетГруппировкиПоПолюГруппировки(МакетКомпоновки, "Валюта");
	
	Для Каждого Элемент Из МассивДляУдаления Цикл
		МакетШапкиОтчета.Макет.Удалить(Элемент);
	КонецЦикла;
	
	Для Каждого Макет Из МакетКомпоновки.Макеты Цикл 
		Если Макет = МакетШапкиОтчета Тогда
		Иначе			
			Индекс = -1;
			МассивПоказателей = Новый Массив;
			МассивПоказателей.Добавить("БУ");
			МассивПоказателей.Добавить("НУ");
			
			Для Каждого ИмяПоказателя Из МассивПоказателей Цикл
				Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда
					Индекс = Индекс + 1;
				КонецЕсли;
			КонецЦикла;
			Если ПараметрыОтчета.ПоказательРазница Тогда 
				Индекс = Индекс + 1;					
			КонецЕсли;
			
			Если ПараметрыОтчета.ПоказательВалютнаяСумма И КоличествоПоказателей = 1 Тогда 
			
			ИначеЕсли ПараметрыОтчета.ПоказательВалютнаяСумма Тогда
				Индекс = Индекс + 1;				
				Если МакетГруппировкиВалюта.Найти(Макет) <> Неопределено ИЛИ Макет = МакетПодвалаОтчета Тогда
			
				Иначе
					Макет.Макет.Удалить(Макет.Макет[Индекс]);
					Индекс = Индекс - 1;
				КонецЕсли;
			КонецЕсли;
			
			Если ПараметрыОтчета.ПоказательКоличество Тогда
				Индекс = Индекс + 1;
				Если МакетГруппировкиВалюта.Найти(Макет) <> Неопределено Тогда
					Макет.Макет.Удалить(Макет.Макет[Индекс]);
				КонецЕсли;
			КонецЕсли;	
		КонецЕсли;
	КонецЦикла;
		
КонецПроцедуры

Процедура ПослеВыводаРезультата(ПараметрыОтчета, Результат) Экспорт
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(ПараметрыОтчета.ИдентификаторОтчета, Результат);

	Если Результат.Области.Найти("Заголовок") = Неопределено Тогда
		Результат.ФиксацияСверху = ПараметрыОтчета.ВысотаШапки;
	Иначе
		Результат.ФиксацияСверху = Результат.Области.Заголовок.Низ + ПараметрыОтчета.ВысотаШапки;
	КонецЕсли;

	Результат.ФиксацияСлева = 0;
	
КонецПроцедуры

Функция ПолучитьНаборПоказателей() Экспорт
	
	НаборПоказателей = Новый Массив;
	НаборПоказателей.Добавить("БУ");
	НаборПоказателей.Добавить("НУ");
	НаборПоказателей.Добавить("Разница");
	НаборПоказателей.Добавить("ВалютнаяСумма");
	НаборПоказателей.Добавить("Количество");
	
	Возврат НаборПоказателей;
	
КонецФункции

// Задает набор опций, которые позволяет настраивать отчет.
//
// Возвращаемое значение:
//   Массив      - имена опций.
//
Функция СохраняемыеОпции() Экспорт
	
	КоллекцияНастроек = Новый Массив;
	Для каждого Показатель Из ПолучитьНаборПоказателей() Цикл
		КоллекцияНастроек.Добавить("Показатель" + Показатель);
	КонецЦикла;
	КоллекцияНастроек.Добавить("РазвернутоеСальдо");
	КоллекцияНастроек.Добавить("ВключатьОбособленныеПодразделения");
	КоллекцияНастроек.Добавить("ПоСубсчетам");
	КоллекцияНастроек.Добавить("СписокВидовСубконто");
	КоллекцияНастроек.Добавить("Периодичность");
	КоллекцияНастроек.Добавить("РазмещениеДополнительныхПолей");
	
	Возврат КоллекцияНастроек;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция ПолучитьТекстЗаголовка(ПараметрыОтчета, ОрганизацияВНачале = Истина) Экспорт 
	
	ТекстСубконто = "";
	Для Каждого ВидСубконто Из ПараметрыОтчета.СписокВидовСубконто Цикл
		ТекстСубконто = ТекстСубконто + ВидСубконто + ", ";	
	КонецЦикла;
	Если Не ПустаяСтрока(ТекстСубконто) Тогда
		ТекстСубконто = Лев(ТекстСубконто, СтрДлина(ТекстСубконто) - 2);
	КонецЕсли;
	
	ЗаголовокОтчета = НСтр("ru='Анализ субконто ';uk='Аналіз субконто '") + ТекстСубконто + БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(ПараметрыОтчета.НачалоПериода, ПараметрыОтчета.КонецПериода);
	
	Возврат ЗаголовокОтчета;
	
КонецФункции

#КонецЕсли