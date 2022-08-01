#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОсновноеСредствоПриИзменении(Элемент)
	
	Если ПолучитьЗначениеРеквизита(Запись.ОсновноеСредство) <> ПредопределенноеЗначение("Перечисление.ИНАГРО_ВидыТехники.Сельхозтехника") Тогда
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru='Выбранное ОС не является сельхозтехникой!';uk='Обраний ОЗ не є сільгосптехнікою!'");
		Сообщение.Сообщить();
		
		Запись.ОсновноеСредство = ПредопределенноеЗначение("Справочник.ОсновныеСредства.ПустаяСсылка"); 
		
	КонецЕсли;      	
	
КонецПроцедуры 

#КонецОбласти    

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ПолучитьЗначениеРеквизита(ОсновноеСредство)
	
	Возврат	ОсновноеСредство.Модель.ВидТехники;
	
КонецФункции

#КонецОбласти 
