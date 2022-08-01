
#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьИтоги(Форма)

	ОбъектФормы = Форма.Объект;

	МассивТабличныхЧастейДляРасчетаИтогов = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок("ПериодыСмены", ",");
	
	ЧасовВсего = 0;
	ЧасовВечернихВсего = 0;
	ЧасовНочныхВсего = 0;
	
	НачалоВечерних     = 72000;  // 20:00:00
	ОкончаниеВечерних  = 79199;  // 21:59:59
	НачалоНочных1      = 0;      // 00:00:00
	ОкончаниеНочных1   = 21600;  // 06:00:00
	НачалоНочных2      = 79200;  // 22:00:00
	ОкончаниеНочных2   = 108000; // 06:00:00

	Для Каждого ТекущаяТабличнаяЧасть Из МассивТабличныхЧастейДляРасчетаИтогов Цикл
		Для Каждого ПериодСмены Из ОбъектФормы[ТекущаяТабличнаяЧасть] Цикл
		ПериодСменыВремяНачала    = НачалоДня(ПериодСмены.ВремяНачала) + (ПериодСмены.ВремяНачала - НачалоДня(ПериодСмены.ВремяНачала));
		ПериодСменыВремяОкончания = НачалоДня(ПериодСмены.ВремяНачала) + (ПериодСмены.ВремяОкончания - НачалоДня(ПериодСмены.ВремяОкончания)) + ?(ПериодСмены.ВремяОкончания < ПериодСмены.ВремяНачала, 86400, 0);
		
		ЧасовВсего = ЧасовВсего + (ПериодСменыВремяОкончания - ПериодСменыВремяНачала);
		
		НачалоВечернихЧасов = Макс(ПериодСменыВремяНачала, НачалоДня(ПериодСмены.ВремяНачала) + НачалоВечерних);
		ОкончаниеВечернихЧасов = Мин(ПериодСменыВремяОкончания, НачалоДня(ПериодСмены.ВремяНачала) + ОкончаниеВечерних);
		
		ЧасовВечернихВсего = ЧасовВечернихВсего + Макс(ОкончаниеВечернихЧасов - НачалоВечернихЧасов, 0);
		
		НачалоНочныхЧасов = Макс(ПериодСменыВремяНачала, НачалоДня(ПериодСмены.ВремяНачала) + НачалоНочных1);
		ОкончаниеНочныхЧасов = Мин(ПериодСменыВремяОкончания, НачалоДня(ПериодСмены.ВремяНачала) + ОкончаниеНочных1);
		
		ЧасовНочныхВсего = ЧасовНочныхВсего + Макс(ОкончаниеНочныхЧасов - НачалоНочныхЧасов, 0);
		
		НачалоНочныхЧасов = Макс(ПериодСменыВремяНачала, НачалоДня(ПериодСмены.ВремяНачала) + НачалоНочных2);
		ОкончаниеНочныхЧасов = Мин(ПериодСменыВремяОкончания, НачалоДня(ПериодСмены.ВремяНачала) + ОкончаниеНочных2);
		
		ЧасовНочныхВсего = ЧасовНочныхВсего + Макс(ОкончаниеНочныхЧасов - НачалоНочныхЧасов, 0);
		
		КонецЦикла;
	КонецЦикла;
	
	Форма.Объект.Часов    = Окр (ЧасовВсего / 3600, 2);
	Форма.Объект.ЧасовВечерних = Окр (ЧасовВечернихВсего / 3600,2);
	Форма.Объект.ЧасовНочных   = Окр (ЧасовНочныхВсего / 3600,2);

КонецПроцедуры 

&НаКлиенте
Процедура ПериодыСменыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	ОбновитьИтоги(ЭтаФорма)
	
КонецПроцедуры

#КонецОбласти 