&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Заголовок", НСтр("ru='Документы по контрагенту';uk='Документи по контрагенту'"));
	ПараметрыФормы.Вставить("Отбор", Новый Структура("Контрагент", ПараметрКоманды));
	ПараметрыФормы.Вставить("КлючНазначенияИспользования", "ДокументыПоКонтрагенту"); 
	
	ОткрытьФорму("ЖурналДокументов.ЖурналОпераций.Форма.ФормаСписка", ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры
