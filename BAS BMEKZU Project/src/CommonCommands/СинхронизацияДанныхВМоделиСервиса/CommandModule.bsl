#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОткрытьФорму("ОбщаяФорма.СинхронизацияДанных",,
			ПараметрыВыполненияКоманды.Источник,
			ПараметрыВыполненияКоманды.Уникальность,
			ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

#КонецОбласти
