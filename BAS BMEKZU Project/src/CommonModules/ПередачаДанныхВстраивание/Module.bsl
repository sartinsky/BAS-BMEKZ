#Область СлужебныйПрограммныйИнтерфейс

Процедура МенеджерыЛогическихХранилищ(ВсеМенеджерыЛогическихХранилищ) Экспорт
    
    Если ТехнологияСервисаИнтеграцияСБСП.ПодсистемаСуществует("ТехнологияСервиса.ПоставляемыеДанныеОбластейДанных") Тогда
        МодульПоставляемыеДанныеОбластейДанных = ТехнологияСервисаИнтеграцияСБСП.ОбщийМодуль("ПоставляемыеДанныеОбластейДанных");
		ВсеМенеджерыЛогическихХранилищ.Вставить("supplied_data", МодульПоставляемыеДанныеОбластейДанных);
    КонецЕсли; 
    
    Если ТехнологияСервисаИнтеграцияСБСП.ПодсистемаСуществует("ТехнологияСервиса.ОчередьЗаданийВнешнийИнтерфейс") Тогда
        МодульОчередьЗаданийВнешнийИнтерфейс = ТехнологияСервисаИнтеграцияСБСП.ОбщийМодуль("ОчередьЗаданийВнешнийИнтерфейс");
        ИдентификаторХранилища = МодульОчередьЗаданийВнешнийИнтерфейс.ИдентификаторХранилища();
		ВсеМенеджерыЛогическихХранилищ.Вставить(ИдентификаторХранилища, МодульОчередьЗаданийВнешнийИнтерфейс);
    КонецЕсли; 
    
    Если ТехнологияСервисаИнтеграцияСБСП.ПодсистемаСуществует("ТехнологияСервиса.ФайлыОбластейДанных") Тогда
        МодульФайлыОбластейДанных = ТехнологияСервисаИнтеграцияСБСП.ОбщийМодуль("ФайлыОбластейДанных");
        ИдентификаторХранилища = МодульФайлыОбластейДанных.ИдентификаторХранилища();
		ВсеМенеджерыЛогическихХранилищ.Вставить(ИдентификаторХранилища, МодульФайлыОбластейДанных);
    КонецЕсли; 
    
    Если ТехнологияСервисаИнтеграцияСБСП.ПодсистемаСуществует("ТехнологияСервиса.ИнтеграцияОбъектовОбластейДанных") Тогда
        МодульИнтеграцияОбъектовОбластейДанных = ТехнологияСервисаИнтеграцияСБСП.ОбщийМодуль("ИнтеграцияОбъектовОбластейДанных");
        ИдентификаторХранилища = МодульИнтеграцияОбъектовОбластейДанных.ИдентификаторХранилища();
		ВсеМенеджерыЛогическихХранилищ.Вставить(ИдентификаторХранилища, МодульИнтеграцияОбъектовОбластейДанных);
    КонецЕсли;
	
	Если ТехнологияСервисаИнтеграцияСБСП.ПодсистемаСуществует("ТехнологияСервиса.МиграцияПриложений") Тогда
        МодульМиграцияПриложений = ТехнологияСервисаИнтеграцияСБСП.ОбщийМодуль("МиграцияПриложений");
		ВсеМенеджерыЛогическихХранилищ.Вставить("migration", МодульМиграцияПриложений);
    КонецЕсли;
    
    Если ТехнологияСервисаИнтеграцияСБСП.ПодсистемаСуществует("ТехнологияСервиса.АсинхронноеПолучениеДанных") Тогда
        МодульАсинхронноеПолучениеДанных = ТехнологияСервисаИнтеграцияСБСП.ОбщийМодуль("АсинхронноеПолучениеДанных");
        ИдентификаторХранилища = МодульАсинхронноеПолучениеДанных.ИдентификаторХранилища();
        ВсеМенеджерыЛогическихХранилищ.Вставить(ИдентификаторХранилища, МодульАсинхронноеПолучениеДанных);
    КонецЕсли;     
    
КонецПроцедуры

Процедура МенеджерыФизическихХранилищ(ВсеМенеджерыФизическихХранилищ) Экспорт
	
КонецПроцедуры

Процедура ПериодДействияВременногоИдентификатора(ПериодДействияВременногоИдентификатора) Экспорт
	
КонецПроцедуры

Процедура РазмерБлокаПолученияДанных(РазмерБлокаПолученияДанных) Экспорт
	
КонецПроцедуры

Процедура РазмерБлокаОтправкиДанных(РазмерБлокаОтправкиДанных) Экспорт
	
КонецПроцедуры

Процедура ОшибкаПриПолученииДанных(Ответ) Экспорт
	
	ОбщегоНазначенияБТС.ЗаписьТехнологическогоЖурнала("ПолучениеДанных.Ошибка", Новый Структура("КодСостояния, Описание", Ответ.КодСостояния, Ответ.ПолучитьТелоКакСтроку()));
	
КонецПроцедуры

Процедура ОшибкаПриОтправкеДанных(Ответ) Экспорт
	
	ОбщегоНазначенияБТС.ЗаписьТехнологическогоЖурнала("ОтправкаДанных.Ошибка", Новый Структура("КодСостояния, Описание", Ответ.КодСостояния, Ответ.ПолучитьТелоКакСтроку()));
	
КонецПроцедуры

Процедура ПриПолученииИмениВременногоФайла(ИмяВременногоФайла, Расширение) Экспорт
	
КонецПроцедуры

Процедура ПриПродленииДействияВременногоИдентификатора(Идентификатор, Дата, Запрос) Экспорт

КонецПроцедуры

#КонецОбласти