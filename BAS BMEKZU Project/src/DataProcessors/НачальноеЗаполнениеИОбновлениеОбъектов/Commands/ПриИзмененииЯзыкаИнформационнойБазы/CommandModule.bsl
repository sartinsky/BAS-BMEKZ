#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("", );
	ОткрытьФорму("Обработка.НачальноеЗаполнениеИОбновлениеОбъектов.Форма.ПриИзмененииЯзыкаИнформационнойБазы",
	             ПараметрыФормы, 
				 ПараметрыВыполненияКоманды.Источник, 
	             "Обработка.НачальноеЗаполнениеИОбновлениеОбъектов.Форма.ПриИзмененииЯзыкаИнформационнойБазы" + ?(ПараметрыВыполненияКоманды.Окно = Неопределено, ".ОтдельноеОкно", ""), 
				 ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

#КонецОбласти
