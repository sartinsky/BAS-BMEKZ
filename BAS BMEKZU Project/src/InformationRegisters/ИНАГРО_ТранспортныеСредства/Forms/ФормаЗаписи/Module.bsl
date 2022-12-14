#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОсновноеСредствоПриИзменении(Элемент)
	 	
	Если ПолучитьЗначениеРеквизита(Запись.ОсновноеСредство) <> ПредопределенноеЗначение("Перечисление.ИНАГРО_ВидыТехники.Автотранспорт") Тогда
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru='Выбранное ОС не является автотранспортом!';uk='Обраний ОЗ не є автотранспортом!'");
		Сообщение.Сообщить(); 
		
		Запись.ОсновноеСредство = ПредопределенноеЗначение("Справочник.ОсновныеСредства.ПустаяСсылка"); 
		
	КонецЕсли;  	
	
КонецПроцедуры 

#КонецОбласти 

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипДвигателяПриИзменении(Элемент)
	
	Если Запись.ТипДвигателя = ПредопределенноеЗначение("Перечисление.ИНАГРО_ТипыДвигателей.Бензиновый") Тогда
		Запись.КоэффРасхода = 2;
	Иначе
		Запись.КоэффРасхода = 1.3;
	КонецЕсли;

КонецПроцедуры 

#КонецОбласти    

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ПолучитьЗначениеРеквизита(ОсновноеСредство)
	
	Возврат	ОсновноеСредство.Модель.ВидТехники;
	
КонецФункции

#КонецОбласти