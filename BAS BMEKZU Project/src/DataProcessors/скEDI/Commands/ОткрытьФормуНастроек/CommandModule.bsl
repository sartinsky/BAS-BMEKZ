
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ПараметрыФормы = Новый Структура("Организация", ПараметрКоманды);
	Если скEDI_ОбщегоНазначения.ЭтоПлатформа82() Тогда
		ОткрытьФормуМодально("ОбщаяФорма.скEDI_ФормаНастроек", ПараметрыФормы);
	Иначе
		ОткрытьФорму("ОбщаяФорма.скEDI_ФормаНастроек", ПараметрыФормы, , Ложь);
	КонецЕсли;
КонецПроцедуры
