
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ПараметрыФормы = Новый Структура("Раздел, Заголовок", "Продажи", НСтр("ru='Полезная информация по разделу ""Продажи""';uk='Корисна інформація по розділу ""Продажі""'"));
	ОткрытьФорму("ОбщаяФорма.ПолезнаяИнформация", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, "ПолезнаяИнформацияПоРазделуПродажи", ПараметрыВыполненияКоманды.Окно);
КонецПроцедуры
