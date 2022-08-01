
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ПериодДляРегистровНакопления = КонецПериода(ДобавитьМесяц(ТекущаяДатаСеанса(), -1));
	ПериодДляРегистровБухгалтерии = КонецПериода(ТекущаяДатаСеанса());
	
	Элементы.ПериодДляРегистровБухгалтерии.Доступность  = Параметры.РегБухгалтерии;
	Элементы.ПериодДляРегистровНакопления.Доступность = Параметры.РегНакопления;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПериодДляРегистровНакопленияПриИзменении(Элемент)
	
	ПериодДляРегистровНакопления = КонецПериода(ПериодДляРегистровНакопления);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодДляРегистровБухгалтерииПриИзменении(Элемент)
	
	ПериодДляРегистровБухгалтерии = КонецПериода(ПериодДляРегистровБухгалтерии);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	РезультатВыбора = Новый Структура("ПериодДляРегистровНакопления, ПериодДляРегистровБухгалтерии");
	ЗаполнитьЗначенияСвойств(РезультатВыбора, ЭтотОбъект);
	
	ОповеститьОВыборе(РезультатВыбора);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Функция КонецПериода(Дата)
	
	Возврат КонецДня(КонецМесяца(Дата));
	
КонецФункции

#КонецОбласти
