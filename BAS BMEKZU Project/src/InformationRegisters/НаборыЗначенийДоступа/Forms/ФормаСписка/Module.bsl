
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ТолькоПросмотр = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВключитьВозможностьРедактирования(Команда)
	
	ТолькоПросмотр = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	Список.КомпоновщикНастроек.Настройки.УсловноеОформление.Элементы.Очистить();
	
	
	ЭлементОформления = Список.КомпоновщикНастроек.Настройки.УсловноеОформление.Элементы.Добавить();
	ЭлементОформления.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='Проверка права Чтение';uk='Перевірка права Читання'"));
	
	ЭлементОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ЭтоПроверкаПраваТаблицы");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение = Истина;
	
	ЭлементОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Уточнение");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение = Справочники.ИдентификаторыОбъектовМетаданных.ПустаяСсылка();
	
	ЭлементПоля = ЭлементОформления.Поля.Элементы.Добавить();
	ЭлементПоля.Поле = Новый ПолеКомпоновкиДанных("Уточнение");
	
	
	ЭлементОформления = Список.КомпоновщикНастроек.Настройки.УсловноеОформление.Элементы.Добавить();
	ЭлементОформления.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='Проверка права Изменение';uk='Перевірка права Зміна'"));
	
	ЭлементОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ЭтоПроверкаПраваТаблицы");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение = Истина;
	
	ЭлементОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Уточнение");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ЭлементОтбора.ПравоеЗначение = Справочники.ИдентификаторыОбъектовМетаданных.ПустаяСсылка();
	
	ЭлементПоля = ЭлементОформления.Поля.Элементы.Добавить();
	ЭлементПоля.Поле = Новый ПолеКомпоновкиДанных("Уточнение");
	
КонецПроцедуры

#КонецОбласти
