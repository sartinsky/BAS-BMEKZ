
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Заголовок", НСтр("ru='Документы поставщиков';uk='Документи постачальників'"));
	ПараметрыФормы.Вставить("КлючНазначенияИспользования", "ДокументыПоставщиков");
	
	ОткрытьФорму("ЖурналДокументов.ЖурналОпераций.ФормаСписка", ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры
