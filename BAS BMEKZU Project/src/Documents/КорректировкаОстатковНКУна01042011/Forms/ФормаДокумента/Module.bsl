
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если РеквизитФормыВЗначение("Объект").ЭтоНовый() Тогда
						
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru='Ввод новых документов ""Корректировка остатков в связи с вступлением в силу норм НКУ на 01.04.2011"" запрещен!';uk='Введення нових документів ""Коригування залишків у зв''язку з набуттям чинності норм ПКУ на 01.04.2011"" заборонене!'");
		Сообщение.Сообщить();
		
		Отказ = Истина;
		
		Возврат;
			
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	ОбщегоНазначенияБПКлиент.ОбработкаОповещенияФормыДокумента(ЭтаФорма, Объект.Ссылка, ИмяСобытия, Параметр, Источник);

КонецПроцедуры
