#Область ПрограммныйИнтерфейс

#Область ПереходНа21

// ИНАГРО.
//
Процедура Обновление_ПереходНа21() Экспорт
	
	//НачатьТранзакцию();

	Попытка
		
		НачатьТранзакцию();
			ПереходНа21Документы();
		ЗафиксироватьТранзакцию();
		
		НачатьТранзакцию();
			ПереходНа21Перечисления();
		ЗафиксироватьТранзакцию();
		
		НачатьТранзакцию();
			ПереходНа21РН(); 
		ЗафиксироватьТранзакцию();
		
		НачатьТранзакцию();
			ВыполнитьКорректировкуРеглОтчетов();
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		//ОтменитьТранзакцию();
		
		ТекстСообщения = НСтр("ru='Операция не выполнена';uk='Операція не виконана'");
		ЗаписьЖурналаРегистрации(ТекстСообщения, УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
		ВызватьИсключение;
		
	КонецПопытки;

	//ЗафиксироватьТранзакцию();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Документы

// ИНАГРО.
//
Процедура ПереходНа21Документы()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	НалоговаяНакладная.Ссылка КАК Ссылка,
		|	НалоговаяНакладная.УдалитьВключаетсяВУточняющийРасчет КАК УдалитьВключаетсяВУточняющийРасчет,
		|	НалоговаяНакладная.УдалитьНомерГТД КАК УдалитьНомерГТД,
		|	НалоговаяНакладная.УдалитьПодтверждаетсяГТД КАК УдалитьПодтверждаетсяГТД,
		|	НалоговаяНакладная.УдалитьПоставкаДипПредставительству КАК УдалитьПоставкаДипПредставительству,
		|	НалоговаяНакладная.УдалитьУточняемыйПериод КАК УдалитьУточняемыйПериод
		|ИЗ
		|	Документ.НалоговаяНакладная КАК НалоговаяНакладная";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		ДокОбъект = Выборка.Ссылка.ПолучитьОбъект();
		ДокОбъект.ОбменДанными.Загрузка = Истина;
		ДокОбъект.ВключаетсяВУточняющийРасчет	 = Выборка.УдалитьВключаетсяВУточняющийРасчет;
		ДокОбъект.НомерГТД						 = Выборка.УдалитьНомерГТД;
		ДокОбъект.ПодтверждаетсяГТД				 = Выборка.УдалитьПодтверждаетсяГТД;
		ДокОбъект.ПоставкаДипПредставительству	 = Выборка.УдалитьПоставкаДипПредставительству;
		ДокОбъект.УточняемыйПериод				 = Выборка.УдалитьУточняемыйПериод;
		ДокОбъект.Записать();
		
	КонецЦикла;
		
КонецПроцедуры

#КонецОбласти

#Область РегистрыНакопления

// ИНАГРО.
//   
Процедура ПереходНа21РН()

	ПереходНа21РН_ОжидаемыйИПодтвержденныйНДСПриобретений();
	ПереходНа21РН_ОжидаемыйИПодтвержденныйНДСПродаж();
	ПереходНа21РН_ПриобретенияНалоговыйУчет();
	ПереходНа21РН_ПродажиНалоговыйУчет();
	
КонецПроцедуры

// ИНАГРО.
//
Процедура ПереходНа21РН_ОжидаемыйИПодтвержденныйНДСПриобретений()

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	УдалитьОжидаемыйИПодтвержденныйНДСПриобретений.Период КАК Период,
		|	УдалитьОжидаемыйИПодтвержденныйНДСПриобретений.Регистратор КАК Регистратор,
		|	УдалитьОжидаемыйИПодтвержденныйНДСПриобретений.НомерСтроки КАК НомерСтроки,
		|	УдалитьОжидаемыйИПодтвержденныйНДСПриобретений.Активность КАК Активность,
		|	УдалитьОжидаемыйИПодтвержденныйНДСПриобретений.ВидДвижения КАК ВидДвижения,
		|	УдалитьОжидаемыйИПодтвержденныйНДСПриобретений.Организация КАК Организация,
		|	УдалитьОжидаемыйИПодтвержденныйНДСПриобретений.ДоговорКонтрагента КАК ДоговорКонтрагента,
		|	УдалитьОжидаемыйИПодтвержденныйНДСПриобретений.Сделка КАК Сделка,
		|	УдалитьОжидаемыйИПодтвержденныйНДСПриобретений.ВозвратнаяТара КАК ВозвратнаяТара,
		|	УдалитьОжидаемыйИПодтвержденныйНДСПриобретений.СобытиеНДС КАК СобытиеНДС,
		|	УдалитьОжидаемыйИПодтвержденныйНДСПриобретений.СтавкаНДС КАК СтавкаНДС,
		|	УдалитьОжидаемыйИПодтвержденныйНДСПриобретений.ДляХозяйственнойДеятельности КАК ДляХозяйственнойДеятельности,
		|	УдалитьОжидаемыйИПодтвержденныйНДСПриобретений.ВидДеятельностиНДС КАК ВидДеятельностиНДС,
		|	УдалитьОжидаемыйИПодтвержденныйНДСПриобретений.Амортизируется КАК Амортизируется,
		|	УдалитьОжидаемыйИПодтвержденныйНДСПриобретений.БазаНДС КАК БазаНДС,
		|	УдалитьОжидаемыйИПодтвержденныйНДСПриобретений.СуммаНДС КАК СуммаНДС,
		|	УдалитьОжидаемыйИПодтвержденныйНДСПриобретений.СуммаНДСПропорционально КАК СуммаНДСПропорционально,
		|	УдалитьОжидаемыйИПодтвержденныйНДСПриобретений.КодОперации КАК КодОперации
		|ИЗ
		|	РегистрНакопления.УдалитьОжидаемыйИПодтвержденныйНДСПриобретений КАК УдалитьОжидаемыйИПодтвержденныйНДСПриобретений
		|ИТОГИ ПО
		|	Регистратор";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаРегистратор = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаРегистратор.Следующий() Цикл
		
		Набор = РегистрыНакопления.ОжидаемыйИПодтвержденныйНДСПриобретений.СоздатьНаборЗаписей();
		Набор.Отбор.Регистратор.Установить(ВыборкаРегистратор.Регистратор);
		Набор.ОбменДанными.Загрузка = Истина;
		
		НаборДляУдаления = РегистрыНакопления.УдалитьОжидаемыйИПодтвержденныйНДСПриобретений.СоздатьНаборЗаписей();
		НаборДляУдаления.Отбор.Регистратор.Установить(ВыборкаРегистратор.Регистратор);
		НаборДляУдаления.ОбменДанными.Загрузка = Истина;
		
		Выборка = ВыборкаРегистратор.Выбрать();
	
		Пока Выборка.Следующий() Цикл
			Запись = Набор.Добавить();
			ЗаполнитьЗначенияСвойств(Запись,Выборка);
		КонецЦикла;
		
		Набор.Записать();
		НаборДляУдаления.Записать();
	КонецЦикла;
	
КонецПроцедуры

// ИНАГРО.
//
Процедура ПереходНа21РН_ОжидаемыйИПодтвержденныйНДСПродаж()

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	УдалитьОжидаемыйИПодтвержденныйНДСПродаж.Период КАК Период,
		|	УдалитьОжидаемыйИПодтвержденныйНДСПродаж.Регистратор КАК Регистратор,
		|	УдалитьОжидаемыйИПодтвержденныйНДСПродаж.НомерСтроки КАК НомерСтроки,
		|	УдалитьОжидаемыйИПодтвержденныйНДСПродаж.Активность КАК Активность,
		|	УдалитьОжидаемыйИПодтвержденныйНДСПродаж.ВидДвижения КАК ВидДвижения,
		|	УдалитьОжидаемыйИПодтвержденныйНДСПродаж.Организация КАК Организация,
		|	УдалитьОжидаемыйИПодтвержденныйНДСПродаж.ДоговорКонтрагента КАК ДоговорКонтрагента,
		|	УдалитьОжидаемыйИПодтвержденныйНДСПродаж.Сделка КАК Сделка,
		|	УдалитьОжидаемыйИПодтвержденныйНДСПродаж.ВозвратнаяТара КАК ВозвратнаяТара,
		|	УдалитьОжидаемыйИПодтвержденныйНДСПродаж.СобытиеНДС КАК СобытиеНДС,
		|	УдалитьОжидаемыйИПодтвержденныйНДСПродаж.СтавкаНДС КАК СтавкаНДС,
		|	УдалитьОжидаемыйИПодтвержденныйНДСПродаж.БазаНДС КАК БазаНДС,
		|	УдалитьОжидаемыйИПодтвержденныйНДСПродаж.СуммаНДС КАК СуммаНДС,
		|	УдалитьОжидаемыйИПодтвержденныйНДСПродаж.КодОперации КАК КодОперации,
		|	УдалитьОжидаемыйИПодтвержденныйНДСПродаж.МоментВремени КАК МоментВремени
		|ИЗ
		|	РегистрНакопления.УдалитьОжидаемыйИПодтвержденныйНДСПродаж КАК УдалитьОжидаемыйИПодтвержденныйНДСПродаж
		|ИТОГИ ПО
		|	Регистратор";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаРегистратор = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаРегистратор.Следующий() Цикл
		
		Набор = РегистрыНакопления.ОжидаемыйИПодтвержденныйНДСПродаж.СоздатьНаборЗаписей();
		Набор.Отбор.Регистратор.Установить(ВыборкаРегистратор.Регистратор);
		Набор.ОбменДанными.Загрузка = Истина;
		
		НаборДляУдаления = РегистрыНакопления.УдалитьОжидаемыйИПодтвержденныйНДСПродаж.СоздатьНаборЗаписей();
		НаборДляУдаления.Отбор.Регистратор.Установить(ВыборкаРегистратор.Регистратор);
		НаборДляУдаления.ОбменДанными.Загрузка = Истина;
		
		Выборка = ВыборкаРегистратор.Выбрать();
	
		Пока Выборка.Следующий() Цикл
			Запись = Набор.Добавить();
			ЗаполнитьЗначенияСвойств(Запись,Выборка);
		КонецЦикла;
		
		Набор.Записать();
		НаборДляУдаления.Записать();
		
	КонецЦикла;
	 
КонецПроцедуры

// ИНАГРО.
//
Процедура ПереходНа21РН_ПриобретенияНалоговыйУчет()

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	УдалитьПриобретенияНалоговыйУчет.Период КАК Период,
		|	УдалитьПриобретенияНалоговыйУчет.Регистратор КАК Регистратор,
		|	УдалитьПриобретенияНалоговыйУчет.НомерСтроки КАК НомерСтроки,
		|	УдалитьПриобретенияНалоговыйУчет.Активность КАК Активность,
		|	УдалитьПриобретенияНалоговыйУчет.ВидДвижения КАК ВидДвижения,
		|	УдалитьПриобретенияНалоговыйУчет.Организация КАК Организация,
		|	УдалитьПриобретенияНалоговыйУчет.ДоговорКонтрагента КАК ДоговорКонтрагента,
		|	УдалитьПриобретенияНалоговыйУчет.Сделка КАК Сделка,
		|	УдалитьПриобретенияНалоговыйУчет.ВозвратнаяТара КАК ВозвратнаяТара,
		|	УдалитьПриобретенияНалоговыйУчет.Событие КАК Событие,
		|	УдалитьПриобретенияНалоговыйУчет.СтавкаНДС КАК СтавкаНДС,
		|	УдалитьПриобретенияНалоговыйУчет.ДляХозяйственнойДеятельности КАК ДляХозяйственнойДеятельности,
		|	УдалитьПриобретенияНалоговыйУчет.ВидДеятельностиНДС КАК ВидДеятельностиНДС,
		|	УдалитьПриобретенияНалоговыйУчет.Амортизируется КАК Амортизируется,
		|	УдалитьПриобретенияНалоговыйУчет.СуммаВзаиморасчетов КАК СуммаВзаиморасчетов,
		|	УдалитьПриобретенияНалоговыйУчет.СуммаНДС КАК СуммаНДС,
		|	УдалитьПриобретенияНалоговыйУчет.СуммаНДСПропорционально КАК СуммаНДСПропорционально,
		|	УдалитьПриобретенияНалоговыйУчет.УДАЛИТЬСуммаВР КАК УДАЛИТЬСуммаВР,
		|	УдалитьПриобретенияНалоговыйУчет.РасчетныйДокумент КАК РасчетныйДокумент,
		|	УдалитьПриобретенияНалоговыйУчет.СчетУчетаНДСПодтвержденный КАК СчетУчетаНДСПодтвержденный,
		|	УдалитьПриобретенияНалоговыйУчет.МоментВремени КАК МоментВремени
		|ИЗ
		|	РегистрНакопления.УдалитьПриобретенияНалоговыйУчет КАК УдалитьПриобретенияНалоговыйУчет
		|ИТОГИ ПО
		|	Регистратор";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаРегистратор = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаРегистратор.Следующий() Цикл
		
		Набор = РегистрыНакопления.ПриобретенияНалоговыйУчет.СоздатьНаборЗаписей();
		Набор.Отбор.Регистратор.Установить(ВыборкаРегистратор.Регистратор);
		Набор.ОбменДанными.Загрузка = Истина;
		
		НаборДляУдаления = РегистрыНакопления.УдалитьПриобретенияНалоговыйУчет.СоздатьНаборЗаписей();
		НаборДляУдаления.Отбор.Регистратор.Установить(ВыборкаРегистратор.Регистратор);
		НаборДляУдаления.ОбменДанными.Загрузка = Истина;
		
		Выборка = ВыборкаРегистратор.Выбрать();
	
		Пока Выборка.Следующий() Цикл
			Запись = Набор.Добавить();
			ЗаполнитьЗначенияСвойств(Запись,Выборка);
		КонецЦикла;
		
		Набор.Записать();
		НаборДляУдаления.Записать();
	КонецЦикла;
	 
КонецПроцедуры

// ИНАГРО.
//
Процедура ПереходНа21РН_ПродажиНалоговыйУчет()

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	УдалитьПродажиНалоговыйУчет.Период КАК Период,
		|	УдалитьПродажиНалоговыйУчет.Регистратор КАК Регистратор,
		|	УдалитьПродажиНалоговыйУчет.НомерСтроки КАК НомерСтроки,
		|	УдалитьПродажиНалоговыйУчет.Активность КАК Активность,
		|	УдалитьПродажиНалоговыйУчет.ВидДвижения КАК ВидДвижения,
		|	УдалитьПродажиНалоговыйУчет.Организация КАК Организация,
		|	УдалитьПродажиНалоговыйУчет.ДоговорКонтрагента КАК ДоговорКонтрагента,
		|	УдалитьПродажиНалоговыйУчет.Сделка КАК Сделка,
		|	УдалитьПродажиНалоговыйУчет.ВозвратнаяТара КАК ВозвратнаяТара,
		|	УдалитьПродажиНалоговыйУчет.Событие КАК Событие,
		|	УдалитьПродажиНалоговыйУчет.СтавкаНДС КАК СтавкаНДС,
		|	УдалитьПродажиНалоговыйУчет.СуммаВзаиморасчетов КАК СуммаВзаиморасчетов,
		|	УдалитьПродажиНалоговыйУчет.СуммаНДС КАК СуммаНДС,
		|	УдалитьПродажиНалоговыйУчет.УДАЛИТЬСуммаВД КАК УДАЛИТЬСуммаВД,
		|	УдалитьПродажиНалоговыйУчет.РасчетныйДокумент КАК РасчетныйДокумент,
		|	УдалитьПродажиНалоговыйУчет.СчетУчетаНДСПодтвержденный КАК СчетУчетаНДСПодтвержденный,
		|	УдалитьПродажиНалоговыйУчет.МоментВремени КАК МоментВремени
		|ИЗ
		|	РегистрНакопления.УдалитьПродажиНалоговыйУчет КАК УдалитьПродажиНалоговыйУчет
		|ИТОГИ ПО
		|	Регистратор";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаРегистратор = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаРегистратор.Следующий() Цикл
		
		Набор = РегистрыНакопления.ПродажиНалоговыйУчет.СоздатьНаборЗаписей();
		Набор.Отбор.Регистратор.Установить(ВыборкаРегистратор.Регистратор);
		Набор.ОбменДанными.Загрузка = Истина;
		
		НаборДляУдаления = РегистрыНакопления.УдалитьПродажиНалоговыйУчет.СоздатьНаборЗаписей();
		НаборДляУдаления.Отбор.Регистратор.Установить(ВыборкаРегистратор.Регистратор);
		НаборДляУдаления.ОбменДанными.Загрузка = Истина;
		
		Выборка = ВыборкаРегистратор.Выбрать();
	
		Пока Выборка.Следующий() Цикл
			Запись = Набор.Добавить();
			ЗаполнитьЗначенияСвойств(Запись,Выборка);
		КонецЦикла;
		
		Набор.Записать();
		НаборДляУдаления.Записать();
	КонецЦикла;
	 
КонецПроцедуры

Процедура ВыполнитьКорректировкуРеглОтчетов() 
	
	// Перезаполняем источники старых отчетов
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	РегламентированныйОтчет.Ссылка КАК Ссылка,
	               |	РегламентированныйОтчет.ИсточникОтчета КАК ИсточникОтчета
	               |ИЗ
	               |	Документ.РегламентированныйОтчет КАК РегламентированныйОтчет";
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Если Выборка.ИсточникОтчета = "ИНАГРО_РегламентированныйОтчетДекларацияЧервертойГруппы" Тогда
			ОтчетОбъект = Выборка.Ссылка.ПолучитьОбъект();
			ОтчетОбъект.ОбменДанными.Загрузка = Истина;
			ОтчетОбъект.ИсточникОтчета = "ИНАГРО_РегламентированныйОтчетДекларацияЧетвертойГруппы";
			ОтчетОбъект.Записать(РежимЗаписиДокумента.Запись);
		ИначеЕсли Выборка.ИсточникОтчета = "ИНАГРО_ОтчетПоРеализацииСельскохозяйственнойПродуцииФорма21" Тогда
			ОтчетОбъект = Выборка.Ссылка.ПолучитьОбъект();
			ОтчетОбъект.ОбменДанными.Загрузка = Истина;
			ОтчетОбъект.ИсточникОтчета = "ИНАГРО_ОтчетПоРеализацииСельскохозяйственнойПродукцииФорма21";
			ОтчетОбъект.Записать(РежимЗаписиДокумента.Запись);
		ИначеЕсли Выборка.ИсточникОтчета = "ИНАГРО_ОсновныеЕкономическиеПоказателиРаботыСельхозПредприятий_50сг" Тогда
			ОтчетОбъект = Выборка.Ссылка.ПолучитьОбъект();
			ОтчетОбъект.ОбменДанными.Загрузка = Истина;
			ОтчетОбъект.ИсточникОтчета = "ИНАГРО_ОсновныеЭкономическиеПоказателиРаботыСельхозПредприятий_50сг";
			ОтчетОбъект.Записать(РежимЗаписиДокумента.Запись);
		КонецЕсли;
	КонецЦикла;
	
	// Скрываем старые элементы в справочнике
	Запрос = Новый Запрос;
	запрос.Текст = "ВЫБРАТЬ
	               |	РегламентированныеОтчеты.Ссылка КАК Ссылка,
	               |	РегламентированныеОтчеты.ИсточникОтчета КАК ИсточникОтчета
	               |ИЗ
	               |	Справочник.РегламентированныеОтчеты КАК РегламентированныеОтчеты";
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
		
	Пока Выборка.Следующий() Цикл
		Если Выборка.ИсточникОтчета = "ИНАГРО_РегламентированныйОтчетДекларацияЧервертойГруппы" Тогда
			МенеджерЗаписи = РегистрыСведений.СкрытыеРегламентированныеОтчеты.СоздатьМенеджерЗаписи();
		    МенеджерЗаписи.РегламентированныйОтчет = Выборка.Ссылка; 
			МенеджерЗаписи.Записать(); 	
		ИначеЕсли Выборка.ИсточникОтчета = "ИНАГРО_ОтчетПоРеализацииСельскохозяйственнойПродуцииФорма21" Тогда
			МенеджерЗаписи = РегистрыСведений.СкрытыеРегламентированныеОтчеты.СоздатьМенеджерЗаписи();
		    МенеджерЗаписи.РегламентированныйОтчет = Выборка.Ссылка; 
			МенеджерЗаписи.Записать(); 	
		ИначеЕсли Выборка.ИсточникОтчета = "ИНАГРО_ОсновныеЕкономическиеПоказателиРаботыСельхозПредприятий_50сг" Тогда
			МенеджерЗаписи = РегистрыСведений.СкрытыеРегламентированныеОтчеты.СоздатьМенеджерЗаписи();
		    МенеджерЗаписи.РегламентированныйОтчет = Выборка.Ссылка; 
			МенеджерЗаписи.Записать(); 	  
		ИначеЕсли Выборка.ИсточникОтчета = "ИНАГРО_РегламентированныйОтчетДекларацияОПрибылиДляСХ" Тогда
			МенеджерЗаписи = РегистрыСведений.СкрытыеРегламентированныеОтчеты.СоздатьМенеджерЗаписи();
		    МенеджерЗаписи.РегламентированныйОтчет = Выборка.Ссылка; 
			МенеджерЗаписи.Записать(); 	
		ИначеЕсли Выборка.ИсточникОтчета = "ИНАГРО_ДанныеОНаличииЗемельныхУчастков" Тогда
			МенеджерЗаписи = РегистрыСведений.СкрытыеРегламентированныеОтчеты.СоздатьМенеджерЗаписи();
		    МенеджерЗаписи.РегламентированныйОтчет = Выборка.Ссылка; 
			МенеджерЗаписи.Записать(); 	 
		ИначеЕсли Выборка.ИсточникОтчета = "ИНАГРО_РегламентированныйОтчетНалоговыйРасчетФСХНалога" Тогда
			МенеджерЗаписи = РегистрыСведений.СкрытыеРегламентированныеОтчеты.СоздатьМенеджерЗаписи();
		    МенеджерЗаписи.РегламентированныйОтчет = Выборка.Ссылка; 
			МенеджерЗаписи.Записать(); 	
		КонецЕсли;
	КонецЦикла;
		
КонецПроцедуры


#КонецОбласти

#Область Перечисления

// ИНАГРО.
//
Процедура ПереходНа21Перечисления()
	
	МассивИзменений = Новый Массив;
	МассивИзменений.Добавить(Перечисления.ВидыСправокОДоходах.УдалитьДоходыИНалоги);
	МассивИзменений.Добавить(Перечисления.ВидыСправокОДоходах.УдалитьСоцстрах2015);
	МассивИзменений.Добавить(Перечисления.ВидыСправокОДоходах.УдалитьСубсидия2015);
	
	ТаблицаРезультат = НайтиПоСсылкам(МассивИзменений);
	
	ИНАГРО_СправкаОДоходах			 = Метаданные.Документы.ИНАГРО_СправкаОДоходах;
	СправкаОДоходах					 = Метаданные.Документы.СправкаОДоходах;
	Если ИНАГРО_ОбщийВызовСервераПовтИсп.ЕстьБСПУ() Тогда
		ИНАГРО_СправкаОДоходахПайщика	 = Метаданные.Документы.ИНАГРО_СправкаОДоходахПайщика;
	КонецЕсли;	
	
	СоответствиеИзменений = Новый Соответствие;
	СоответствиеИзменений.Вставить(Перечисления.ВидыСправокОДоходах.УдалитьДоходыИНалоги,Перечисления.ВидыСправокОДоходах.ДоходыИНалоги);
	СоответствиеИзменений.Вставить(Перечисления.ВидыСправокОДоходах.УдалитьСоцстрах2015,Перечисления.ВидыСправокОДоходах.Соцстрах2015);
	СоответствиеИзменений.Вставить(Перечисления.ВидыСправокОДоходах.УдалитьСубсидия2015,Перечисления.ВидыСправокОДоходах.Субсидия2015);
	
	Для каждого Стр Из ТаблицаРезультат Цикл
	
		Если ИНАГРО_СправкаОДоходах = Стр.Метаданные Тогда
		
			 ДокОбъект = Стр.Данные.ПолучитьОбъект();
			 ДокОбъект.ОбменДанными.Загрузка = Истина;
			 ДокОбъект.ВидСправки = СоответствиеИзменений.Получить(Стр.Ссылка);
			 ДокОбъект.Записать();
			 
		ИначеЕсли ИНАГРО_ОбщийВызовСервераПовтИсп.ЕстьБСПУ() И ИНАГРО_СправкаОДоходахПайщика = Стр.Метаданные Тогда	 
		    		
			 ДокОбъект = Стр.Данные.ПолучитьОбъект();
			 ДокОбъект.ОбменДанными.Загрузка = Истина;
			 ДокОбъект.ВидСправки = СоответствиеИзменений.Получить(Стр.Ссылка);
			 ДокОбъект.Записать(); 
			 
		 ИначеЕсли СправкаОДоходах = Стр.Метаданные Тогда	 
			 
			 ДокОбъект = Стр.Данные.ПолучитьОбъект();
			 ДокОбъект.ОбменДанными.Загрузка = Истина;
			 ДокОбъект.ВидСправки = СоответствиеИзменений.Получить(Стр.Ссылка);
			 ДокОбъект.Записать(); 	

		КонецЕсли;	
	
	КонецЦикла;
	
	
КонецПроцедуры

#КонецОбласти

#Область РегистрыСведений

// ИНАГРО.
//
Процедура ЗаполнитьУчетнуюПолитикупоПерсоналу() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	*
	|ИЗ
	|	РегистрСведений.ИНАГРО_УчетнаяПолитикаПоПерсоналу КАК ИНАГРО_УчетнаяПолитикаПоПерсоналу";

	ТаблицаРезультата = Запрос.Выполнить().Выгрузить();
	
	КоличествоСтрок = ТаблицаРезультата.Количество();
	Для Инд = 1 по КоличествоСтрок Цикл
		Строка = ТаблицаРезультата[Инд-1];
		Строка.ИспользованиеРезерваОтпусков					= Строка.УдалитьИспользованиеРезерваОтпусков;
		Строка.НеВестиУчетПоСубконтоСотрудникиНа661Счете	= Строка.УдалитьНеВестиУчетПоСубконтоСотрудникиНа661Счете;
		Строка.ПрименятьКоэффициентЕСВДляАвансов			= Строка.УдалитьПрименятьКоэффициентЕСВДляАвансов;
		
	КонецЦикла;

	НаборЗаписей = РегистрыСведений.ИНАГРО_УчетнаяПолитикаПоПерсоналу.СоздатьНаборЗаписей();
	НаборЗаписей.Загрузить(ТаблицаРезультата);
	НаборЗаписей.Записать();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти