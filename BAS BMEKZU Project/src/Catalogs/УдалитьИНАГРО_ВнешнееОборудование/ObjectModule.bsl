#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий
	
Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда	
		Возврат;	
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ВидОборудования = Перечисления.ИНАГРО_ВидыВнешнегоОборудования.Весы;
	ИмяКомпьютера 	= ИмяКомпьютера();
	КвоДатчиков		= 1;

КонецПроцедуры

#КонецОбласти 

#КонецЕсли