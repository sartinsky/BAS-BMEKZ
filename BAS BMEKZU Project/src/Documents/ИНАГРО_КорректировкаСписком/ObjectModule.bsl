#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда  

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);	
	
	ИНАГРО_ЭлеваторЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект);

	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения); 	
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
		
КонецПроцедуры 

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Перем Заголовок, СтруктураШапкиДокумента;
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
		   
	// Заголовок Для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначенияБПВызовСервера.ПредставлениеДокументаПриПроведении(Ссылка);

	ПодготовитьСтруктуруШапкиДокумента(Заголовок, СтруктураШапкиДокумента);	
	
	// Движения по документу
	Если НЕ Отказ Тогда		
		ПроводкиПоРегистрамЭлеватора(РежимПроведения, СтруктураШапкиДокумента, Отказ, Заголовок);	
	КонецЕсли;	
		
	ПроведениеСервер.ПодготовитьНаборыЗаписейКЗаписиДвижений(ЭтотОбъект);

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКОтменеПроведения(ЭтотОбъект);
	Движения.Записать();
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	Дата = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
	Ответственный = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

#КонецОбласти

#Область Проведение

// Процедура формирует структуру шапки документа и дополнительных полей.
//
Процедура ПодготовитьСтруктуруШапкиДокумента(Заголовок, СтруктураШапкиДокумента) Экспорт
	
	СтруктураШапкиДокумента = ОбщегоНазначенияРед12.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);

КонецПроцедуры

Процедура ПроводкиПоРегистрамЭлеватора(РежимПроведения, СтруктураШапкиДокумента, Отказ, Заголовок)
	
	Если ПравитьОстатки Тогда
		Для Каждого СтрокаТабличнойЧасти Из Список Цикл
			Если СтрокаТабличнойЧасти.ВидДвижения = Перечисления.ИНАГРО_ВидыДвижений.Расход Тогда
				// расход
				СтруктураДвиженияПроведения(СтруктураШапкиДокумента, СтрокаТабличнойЧасти);
				ИНАГРО_Элеватор.ДвиженияПоРегиструОстаткиРасход(Движения, СтруктураШапкиДокумента);
			ИначеЕсли СтрокаТабличнойЧасти.ВидДвижения = Перечисления.ИНАГРО_ВидыДвижений.Приход Тогда
				// приход
				СтруктураДвиженияПроведения(СтруктураШапкиДокумента, СтрокаТабличнойЧасти);
				ИНАГРО_Элеватор.ДвиженияПоРегиструОстаткиПриход(Движения, СтруктураШапкиДокумента);	
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если ПравитьОстаткиСводные Тогда 
		Для Каждого СтрокаТабличнойЧасти Из Список Цикл
			Если СтрокаТабличнойЧасти.ВидДвижения = Перечисления.ИНАГРО_ВидыДвижений.Расход Тогда
				// расход
				СтруктураДвиженияПроведения(СтруктураШапкиДокумента, СтрокаТабличнойЧасти);
				ИНАГРО_Элеватор.ДвиженияПоРегиструОстаткиСводнаяРасход(Движения, СтруктураШапкиДокумента);
			ИначеЕсли СтрокаТабличнойЧасти.ВидДвижения = Перечисления.ИНАГРО_ВидыДвижений.Приход Тогда
				// приход
				СтруктураДвиженияПроведения(СтруктураШапкиДокумента, СтрокаТабличнойЧасти);
				ИНАГРО_Элеватор.ДвиженияПоРегиструОстаткиСводнаяПриход(Движения, СтруктураШапкиДокумента);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если ПравитьФорму36 Тогда
		Для Каждого СтрокаТабличнойЧасти Из Список Цикл	
			Если СтрокаТабличнойЧасти.ВидДвижения = Перечисления.ИНАГРО_ВидыДвижений.Расход Тогда
				// расход
				СтруктураДвиженияПроведения(СтруктураШапкиДокумента,СтрокаТабличнойЧасти, "Форма36");
				ИНАГРО_Элеватор.ДвиженияПоРегиструФорма36Расход(Движения, СтруктураШапкиДокумента);
			ИначеЕсли СтрокаТабличнойЧасти.ВидДвижения = Перечисления.ИНАГРО_ВидыДвижений.Приход Тогда
				// приход
				СтруктураДвиженияПроведения(СтруктураШапкиДокумента, СтрокаТабличнойЧасти);
				ИНАГРО_Элеватор.ДвиженияПоРегиструФорма36Приход(Движения, СтруктураШапкиДокумента);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если ПравитьФорму36Сводную Тогда
		Для Каждого СтрокаТабличнойЧасти Из Список Цикл	
			Если СтрокаТабличнойЧасти.ВидДвижения = Перечисления.ИНАГРО_ВидыДвижений.Расход Тогда
				// расход
				СтруктураДвиженияПроведения(СтруктураШапкиДокумента, СтрокаТабличнойЧасти, "Форма36");
				ИНАГРО_Элеватор.ДвиженияПоРегиструФорма36СводнаяРасход(Движения, СтруктураШапкиДокумента);
			ИначеЕсли СтрокаТабличнойЧасти.ВидДвижения = Перечисления.ИНАГРО_ВидыДвижений.Приход Тогда
				// приход
				СтруктураДвиженияПроведения(СтруктураШапкиДокумента, СтрокаТабличнойЧасти);
				ИНАГРО_Элеватор.ДвиженияПоРегиструФорма36СводнаяПриход(Движения, СтруктураШапкиДокумента);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

// Структура с реквизитами для проведения
//
Процедура СтруктураДвиженияПроведения(СтруктураШапкиДокумента, СтрокаТабличнойЧасти, Регистр = "Остатки")
	
	// Измерения
	СтруктураШапкиДокумента.Вставить("Организация",        Организация);
	СтруктураШапкиДокумента.Вставить("Владелец",           СтрокаТабличнойЧасти.Владелец);
	СтруктураШапкиДокумента.Вставить("ДоговорКонтрагента", СтрокаТабличнойЧасти.ДоговорКонтрагента);
	СтруктураШапкиДокумента.Вставить("Склад",              СтрокаТабличнойЧасти.Склад);
	СтруктураШапкиДокумента.Вставить("МестоХранения",      СтрокаТабличнойЧасти.МестоХранения);
	СтруктураШапкиДокумента.Вставить("ВидХранения",        СтрокаТабличнойЧасти.ВидХранения);
	СтруктураШапкиДокумента.Вставить("Номенклатура",       СтрокаТабличнойЧасти.Номенклатура);
	СтруктураШапкиДокумента.Вставить("СчетУчетаБУ",        СтрокаТабличнойЧасти.СчетУчетаБУ);	
	СтруктураШапкиДокумента.Вставить("Урожай",             СтрокаТабличнойЧасти.Урожай);
	СтруктураШапкиДокумента.Вставить("ВидДвижения",        СтрокаТабличнойЧасти.ВидДвижения);
	
	Если СтрокаТабличнойЧасти.Фасованное Тогда
		СтруктураШапкиДокумента.Вставить("ВидФасовки", СтрокаТабличнойЧасти.Фасовка);
	Иначе
		СтруктураШапкиДокумента.Вставить("ВидФасовки", Справочники.ИНАГРО_ВидыФасовки.ПустаяСсылка());
	КонецЕсли;
	
	// Ресурсы
	СтруктураШапкиДокумента.Вставить("Количество",         СтрокаТабличнойЧасти.Количество);	
	СтруктураШапкиДокумента.Вставить("ФизическийВес",      СтрокаТабличнойЧасти.Вес);
	СтруктураШапкиДокумента.Вставить("ЗачетныйВес",        СтрокаТабличнойЧасти.ЗачетныйВес);	
	СтруктураШапкиДокумента.Вставить("Влажность",          СтрокаТабличнойЧасти.Влажность);
	СтруктураШапкиДокумента.Вставить("СорнаяПримесь",      СтрокаТабличнойЧасти.СорнаяПримесь);	
	СтруктураШапкиДокумента.Вставить("ЗерноваяПримесь",    СтрокаТабличнойЧасти.ЗерноваяПримесь); 	
	СтруктураШапкиДокумента.Вставить("ВесПоВлажности",     СтрокаТабличнойЧасти.ВесПоВлажности);	
	СтруктураШапкиДокумента.Вставить("ВесПоСорнойПримеси", СтрокаТабличнойЧасти.ВесПоСорнойПримеси);	
	СтруктураШапкиДокумента.Вставить("УбыльВесаПриСушке",  СтрокаТабличнойЧасти.УбыльВесаПриСушке);	
	СтруктураШапкиДокумента.Вставить("Поставщик",          СтрокаТабличнойЧасти.Владелец);
	СтруктураШапкиДокумента.Вставить("Откуда",             СтрокаТабличнойЧасти.Склад);
	СтруктураШапкиДокумента.Вставить("КоличествоМест",     СтрокаТабличнойЧасти.Количество); 
	СтруктураШапкиДокумента.Вставить("ВесОбразцов",        0);
	
	Если  СтруктураШапкиДокумента.СнятьУбыльВесаПриСушкеСОстатка
		И СтрокаТабличнойЧасти.ВидДвижения = Перечисления.ИНАГРО_ВидыДвижений.Расход Тогда			
		Если Регистр = "Остатки" Тогда
			СтруктураШапкиДокумента.ФизическийВес = СтрокаТабличнойЧасти.Вес + СтрокаТабличнойЧасти.УбыльВесаПриСушке;					
		КонецЕсли;
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли