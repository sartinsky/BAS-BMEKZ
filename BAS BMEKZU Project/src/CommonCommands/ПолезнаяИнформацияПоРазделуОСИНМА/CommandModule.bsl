
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ПараметрыФормы = Новый Структура("Раздел, Заголовок", "ОСИНМА", НСтр("ru='Полезная информация по разделу ""ОС и НМА""';uk='Корисна інформація по розділу ""ОС і НМА""'"));
	ОткрытьФорму("ОбщаяФорма.ПолезнаяИнформация", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, "ПолезнаяИнформацияПоРазделуОСИНМА", ПараметрыВыполненияКоманды.Окно);
КонецПроцедуры
