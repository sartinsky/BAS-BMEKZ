#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ПараметрыОткрытия = Новый Структура;
	Если ТипЗнч(ПараметрыВыполненияКоманды.Источник) = Тип("УправляемаяФорма") Тогда
		ПараметрыОткрытия.Вставить("ИдентификаторЗадания", ПараметрыВыполненияКоманды.Источник.ЦентрМониторингаИдентификаторЗадания);
		ПараметрыОткрытия.Вставить("АдресРезультатаЗадания", ПараметрыВыполненияКоманды.Источник.ЦентрМониторингаАдресРезультатаЗадания);
	КонецЕсли;
	ОткрытьФорму("Обработка.НастройкиЦентраМониторинга.Форма.НастройкиЦентраМониторинга", ПараметрыОткрытия, ЭтотОбъект,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

#КонецОбласти