#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	// Вставить содержимое обработчика.
	Отбор = Новый Структура("Программа", ПараметрКоманды);
	ПараметрыФормы = Новый Структура("Отбор", Отбор);
	
	ОткрытьФорму("РегистрСведений.ПутиКПрограммамЭлектроннойПодписиИШифрованияНаСерверахLinux.ФормаСписка",
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно,
		ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры

#КонецОбласти
