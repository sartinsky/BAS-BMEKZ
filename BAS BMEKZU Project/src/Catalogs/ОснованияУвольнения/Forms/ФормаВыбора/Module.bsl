&НаКлиенте
Процедура ПодборИзКлассификатора(Команда)
	
	ОткрытьФорму("Справочник.ОснованияУвольнения.Форма.ПодборИзКлассификатора",, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Элементы.Список.Обновить();
	Элементы.Список.ТекущаяСтрока = ВыбранноеЗначение;
	
КонецПроцедуры

