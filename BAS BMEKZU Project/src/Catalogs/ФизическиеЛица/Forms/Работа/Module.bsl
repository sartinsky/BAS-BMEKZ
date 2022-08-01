////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры, "ФизическоеЛицоСсылка");
	
	ПрочитатьДанные();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СотрудникиКлиент.ЗарегистрироватьОткрытиеФормы(ЭтаФорма, "Работа");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	СотрудникиКлиент.ОбработкаОповещения(ЭтаФорма, ИмяСобытия, Параметр, Источник);
	
	Если  ИмяСобытия = "ИзменениеДанныхМестаРаботы" И Параметр.ФизическоеЛицо = ФизическоеЛицоСсылка Тогда
		ОбработкаИзмененияДанныхОРабочемМестеНаСервере(Параметр.Сотрудник);
	КонецЕсли;	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Перечитать(Команда)
	
	ПрочитатьДанные();
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура НовоеМестоРаботы(Команда)
	СотрудникиКлиент.ОткрытьМестоРаботы(ЭтаФорма);
КонецПроцедуры

&НаКлиенте 
Процедура Подключаемый_ОткрытьФормуСотрудника(Команда)
	СотрудникиКлиент.ОткрытьФормуСотрудника(ЭтаФорма, Команда);	
КонецПроцедуры	

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ПрочитатьДанные()
	
	СотрудникиФормы.ЗаполнитьФормуМестамиРаботы(ЭтаФорма, "Работа", "НовоеМестоРаботы", , Истина);
		
	СотрудникиФормы.УстановитьПараметрыИнфоНадписиФормыФизЛица(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаИзмененияДанныхОРабочемМестеНаСервере(ПараметрСотрудник)
	СотрудникиФормы.ОбработкаИзмененияДанныхОРабочемМесте(ЭтаФорма, ПараметрСотрудник, "Работа","НовоеМестоРаботы", Истина);
КонецПроцедуры

