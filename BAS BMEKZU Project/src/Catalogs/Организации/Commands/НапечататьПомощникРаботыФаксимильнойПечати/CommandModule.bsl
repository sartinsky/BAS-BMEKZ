
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	СтруктураДополнительныхПараметров = Новый Структура("ЗаголовокФормы", НСтр("ru='Как быстро и просто создать факсимильную подпись и печать?';uk='Як швидко і просто створити факсимільний підпис та печатку?'"));
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Справочник.Организации", "НапечататьПомощникРаботыФаксимильнойПечати", ПараметрКоманды, ПараметрыВыполненияКоманды, СтруктураДополнительныхПараметров);
	
КонецПроцедуры
