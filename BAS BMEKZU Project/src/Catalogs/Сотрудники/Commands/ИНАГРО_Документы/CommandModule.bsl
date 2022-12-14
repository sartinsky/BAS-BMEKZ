#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)	

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СотрудникСсылка", ПараметрКоманды);
	ПараметрыФормы.Вставить("КлючНазначенияИспользования", "ИНАГРО_ДокументыПоСотруднику");
	ПараметрыФормы.Вставить("ЗакрыватьПриЗакрытииВладельца", Истина);
	
	ОткрытьФорму("Справочник.Сотрудники.Форма.ИНАГРО_ДокументыПоНачислениям", ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
КонецПроцедуры

#КонецОбласти