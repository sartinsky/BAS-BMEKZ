
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	Отбор = Новый Структура("ВидОперации", ПредопределенноеЗначение("Перечисление.ВидыОперацийПередачаТоваров.ИзПереработки"));
	ПараметрыФормы = Новый Структура("Отбор", Отбор);
	ОткрытьФорму("Документ.ПередачаТоваров.ФормаСписка", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
КонецПроцедуры
