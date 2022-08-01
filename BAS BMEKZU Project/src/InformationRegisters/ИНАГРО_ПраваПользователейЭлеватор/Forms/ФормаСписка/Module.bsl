#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)	
	
	Пользователь = Пользователи.ТекущийПользователь();
	
	ВидСравненияОтбора  = ВидСравненияКомпоновкиДанных.Равно;
	ИспользованиеОтбора = ЗначениеЗаполнено(Пользователь);
	РежимОтображения    = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ;		
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Пользователь", Пользователь,
																			ВидСравненияОтбора, , ИспользованиеОтбора, РежимОтображения); 	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	
	ОбщегоНазначенияБП.ВосстановитьОтборСписка(Список, Настройки, "Пользователь");
	
КонецПроцедуры

#КонецОбласти 
