#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда  
	
Перем ПараметрыУчетаЭлеватора;
Перем СобственноеПодразделение;

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);	
	
	ИНАГРО_ЭлеваторЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект);

	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения); 
	
	Если  ТипДанныхЗаполнения = Тип("Структура")
		И ДанныеЗаполнения.Свойство("ВидОперации") Тогда
		ВидОперации = ДанныеЗаполнения.ВидОперации;
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(Владелец) Тогда		
		Если ИНАГРО_Элеватор.ПолучитьДополнительныйРеквизитКонтрагента(Владелец, "СобственноеПодразделение") Тогда
			ОтражатьПоЗатратам = Истина;
		Иначе
			ОтражатьПоЗатратам = Ложь;
		КонецЕсли;		
	КонецЕсли;
	
	Если ОтражатьПоЗатратам Тогда
		ОтражатьВБухгалтерскомУчете = Ложь;			
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Организация) Тогда
		Руководители = ИНАГРО_Элеватор.ОтветственныеЛицаОрганизации(Организация, Дата);
		НачальникОхраны = Руководители.НачальникОхраны;
	КонецЕсли; 
		
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив; 	
	
	Если ВидОперации = Перечисления.ИНАГРО_ВидыОперацийРеестрТТНВывоз.Вывоз Тогда		
		МассивНепроверяемыхРеквизитов.Добавить("Отходы");						
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);	

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновитьПараметрыУчетаЭлеватора();

	Если НЕ Отказ Тогда
		
		ПараметрыДляРасчетаЗачетногоВеса = ПолучитьПараметрыДляРасчетаЗачетногоВеса();

		ЗачетныйВес = ИНАГРО_Элеватор.ЗачетныйВесПриПроведении(ПараметрыДляРасчетаЗачетногоВеса);
		
	КонецЕсли;
	
	Если НЕ ПараметрыУчетаЭлеватора.ОтключитьАвтоматическоеНачислениеУслуг Тогда		
		ЗаполнитьУслуги();		
	КонецЕсли;	

КонецПроцедуры 

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Перем Заголовок, СтруктураШапкиДокумента; 	
	Перем ТаблицаПоКультурамВвозВывоз;
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
		   
	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначенияБПВызовСервера.ПредставлениеДокументаПриПроведении(Ссылка);

	Если РежимПроведения = РежимПроведенияДокумента.Неоперативный Тогда		
		Если НЕ ПроверитьЗаполнение() Тогда
			Отказ = Истина;
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(МестоХранения) И МестоХранения.Владелец <> Склад Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Место хранения %2 не принадлежит складу %1!';uk='Місце зберігання %2 не належить складу %1!'"), Склад, МестоХранения);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , , , Отказ);
	КонецЕсли;	

	ПодготовитьСтруктуруШапкиДокумента(Заголовок, СтруктураШапкиДокумента);	
	
	ПодготовитьПараметрыУчетнойПолитики(СтруктураШапкиДокумента, Отказ, Заголовок);	
	
	ДополнитьСтруктуруШапкиНужнымиДанными(СтруктураШапкиДокумента, Отказ, Заголовок);
	
	ПодготовитьТаблицуПоКультурамВвозВывоз(СтруктураШапкиДокумента, ТаблицаПоКультурамВвозВывоз, Отказ, Заголовок);

	// Движения по документу
	Если НЕ Отказ Тогда		
		ДвиженияПоРегистрам(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоКультурамВвозВывоз, Отказ, Заголовок);
	КонецЕсли; 		
	
	Движения.Хозрасчетный.ВыполнитьДействияПередЗаписьюДвижений();

	ПроведениеСервер.ПодготовитьНаборыЗаписейКЗаписиДвижений(ЭтотОбъект);	

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКОтменеПроведения(ЭтотОбъект);
	Движения.Записать();
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	Дата = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
	Ответственный = Пользователи.ТекущийПользователь();
		
	ВесБрутто   = 0;
	ВесБрутто1  = 0;
	ВесТары     = 0;
	ВесТары1    = 0;
	ВесНетто    = 0;
	ВесНетто1   = 0; 	
		
	Вес         = 0;
	ВесНеттоДок = 0;	
	
	//
	ВесБруттоКонтроль  = 0;
	ВесБрутто1Контроль = 0;
	ВесТарыКонтроль    = 0;
	ВесТары1Контроль   = 0;
	
	ЛабораторныйАнализ = Документы.ИНАГРО_ЛабораторныйАнализ.ПустаяСсылка();
	
КонецПроцедуры

#КонецОбласти

#Область Проведение

// Процедура формирует структуру шапки документа и дополнительных полей.
//
Процедура ПодготовитьСтруктуруШапкиДокумента(Заголовок, СтруктураШапкиДокумента) Экспорт

	// Дерево значений, содержащее имена необходимых полей в запросе по шапке.
	Перем ДеревоПолейЗапросаПоШапке;	
	
	СтруктураШапкиДокумента   = ОбщегоНазначенияРед12.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);
	
	// Заполним по шапке документа дерево параметров, нужных при проведении.
	ДеревоПолейЗапросаПоШапке = ОбщегоНазначенияРед12.СформироватьДеревоПолейЗапросаПоШапке(); 	
	
	// Сформируем запрос на дополнительные параметры, нужные при проведении, по данным шапки документа.
	СтруктураШапкиДокумента = УправлениеЗапасами.СформироватьЗапросПоДеревуПолей(ЭтотОбъект, ДеревоПолейЗапросаПоШапке, СтруктураШапкиДокумента, "");

КонецПроцедуры

// Процедура определяет параметры учетной политики
//
Процедура ПодготовитьПараметрыУчетнойПолитики(СтруктураШапкиДокумента, Отказ, Заголовок)
	
	СтруктураШапкиДокумента.Вставить("ЕстьНалогНаПрибыльДо2015", УчетнаяПолитика.ПлательщикНалогаНаПрибыльДо2015(СтруктураШапкиДокумента.Организация, СтруктураШапкиДокумента.Дата));
	СтруктураШапкиДокумента.Вставить("ЕстьНДС",                  УчетнаяПолитика.ПлательщикНДС(СтруктураШапкиДокумента.Организация, СтруктураШапкиДокумента.Дата));
	
КонецПроцедуры

Процедура ДополнитьСтруктуруШапкиНужнымиДанными(СтруктураШапкиДокумента, Отказ, Заголовок)
	
	СтруктураШапкиДокумента.Вставить("Количество",     0);
	СтруктураШапкиДокумента.Вставить("КоличествоМест", 0);
	СтруктураШапкиДокумента.Вставить("Поставщик",      Справочники.Контрагенты.ПустаяСсылка());	
	СтруктураШапкиДокумента.Вставить("Откуда",         Склад);		
	СтруктураШапкиДокумента.Вставить("СчетУчетаБУ",    СчетЗатрат);
	СтруктураШапкиДокумента.ФизическийВес = ФизическийВес + ВесОбразцов;	
		
КонецПроцедуры

// Составляет таблицу по культурам и шапке документа
//
Процедура ПодготовитьТаблицуПоКультурамВвозВывоз(СтруктураШапкиДокумента, ТаблицаПоКультурамВвозВывоз, Отказ, Заголовок) Экспорт
			
	СтруктураПолей = Новый Структура();	
	СтруктураПростыхПолей = Новый Структура();		
	
	СтруктураПолей.Вставить("Организация",                 "Ссылка.Организация");	
	СтруктураПолей.Вставить("Владелец",                    "Ссылка.Владелец");
	СтруктураПолей.Вставить("ДоговорКонтрагента",          "Ссылка.ДоговорКонтрагента");
	СтруктураПолей.Вставить("Склад",                       "Ссылка.Склад");
	СтруктураПолей.Вставить("Номенклатура",                "Ссылка.Номенклатура");	
	СтруктураПолей.Вставить("Услуга",                      "Ссылка.Номенклатура.Услуга");
	СтруктураПолей.Вставить("Количество",                  "Ссылка.ФизическийВес");		
	СтруктураПолей.Вставить("ФизическийВес",               "Вес");
	СтруктураПолей.Вставить("Вес",                         "Ссылка.ФизическийВес");
	СтруктураПолей.Вставить("ЗачетныйВес",                 "Ссылка.ЗачетныйВес");		
	СтруктураПолей.Вставить("НоменклатурнаяГруппа",        "Ссылка.Номенклатура.НоменклатурнаяГруппа");      	
	СтруктураПолей.Вставить("СчетУчетаБУ",                 "Ссылка.СчетЗатрат");		
	СтруктураПолей.Вставить("ОтражатьВБухгалтерскомУчете", "Ссылка.ОтражатьВБухгалтерскомУчете");	                                                                                             	
	СтруктураПолей.Вставить("ПоставщикПолучатель",         "Ссылка.Получатель");
	СтруктураПолей.Вставить("ДокументОприходования",       "ТТН");

	//СтруктураПолей.Вставить("КорСчетСписанияБУ",           "Ссылка.СчетЗатрат");
	//СтруктураПолей.Вставить("КорСубконтоСписанияБУ1",      "Ссылка.Субконто1");
	//СтруктураПолей.Вставить("КорСубконтоСписанияБУ2",      "Ссылка.Субконто2"); 				
	//СтруктураПолей.Вставить("КорСубконтоСписанияБУ3",      "Ссылка.Субконто3");
	//СтруктураПолей.Вставить("БланкСтрогогоУчета",          "Ссылка.Номенклатура.БланкСтрогогоУчета");				
	//СтруктураПолей.Вставить("НалоговоеНазначение",         "Ссылка.Номенклатура.НоменклатурнаяГруппа.НалоговоеНазначениеВПроизводстве");	
	//СтруктураПолей.Вставить("ВидНалоговойДеятельности",    "Ссылка.Номенклатура.НоменклатурнаяГруппа.НалоговоеНазначениеВПроизводстве.ВидНалоговойДеятельности");	
	//СтруктураПолей.Вставить("ВидДеятельностиНДС",          "Ссылка.Номенклатура.НоменклатурнаяГруппа.НалоговоеНазначениеВПроизводстве.ВидДеятельностиНДС");
	//СтруктураПолей.Вставить("Амортизируется",              "Ссылка.Номенклатура.НоменклатурнаяГруппа.НалоговоеНазначениеВПроизводстве.Амортизируется");
	
	СтруктураПростыхПолей.Вставить("Ссылка",                                  Ссылка);
	СтруктураПростыхПолей.Вставить("Себестоимость",                           0);
	СтруктураПростыхПолей.Вставить("ВходящийНДС",                             0);	
	СтруктураПростыхПолей.Вставить("Валюта",                                  Неопределено);	
	СтруктураПростыхПолей.Вставить("КоэффОплаты",                             1);
	СтруктураПростыхПолей.Вставить("ПроводкиСуммаБезНДСРегл",                 0);	
	СтруктураПростыхПолей.Вставить("ВидОперацииВвозаВывозаСобственногоЗерна", Перечисления.ИНАГРО_ВидыОперацийВвозаВывозаСобственногоЗерна.РеализацияТоваровУслуг);
		
	РезультатЗапросаТаблицаПоКультурамВвозВывоз = ОбщегоНазначенияРед12.СформироватьЗапросПоТабличнойЧасти(ЭтотОбъект, "СписокТТН", СтруктураПолей, СтруктураПростыхПолей);
	
	ТаблицаПоКультурамВвозВывоз = РезультатЗапросаТаблицаПоКультурамВвозВывоз.Выгрузить();
	
КонецПроцедуры

// Процедура выполняет движения по регистрам
//
Процедура ДвиженияПоРегистрам(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоКультурамВвозВывоз, Отказ, Заголовок)
	
	ВидНоменклатуры                          = ИНАГРО_Элеватор.ПолучитьДополнительныйРеквизитНоменклатуры(Номенклатура, "ВидТМЦ");
	ПроводимЧерезТТН                         = ПараметрыУчетаЭлеватора.НеПроводитьДокументамиРеестрТТНВывоз;	
	ФормироватьРеестрыТТНВывозДляОтходов3Кат = ПараметрыУчетаЭлеватора.ФормироватьРеестрыТТНВывозДляОтходов3Кат;
		
	Проводим = Истина;
	
	Если ПроводимЧерезТТН Тогда 
		Если ФормироватьРеестрыТТНВывозДляОтходов3Кат Тогда
			Если ВидНоменклатуры <> Перечисления.ИНАГРО_ВидыТМЦ.Кат3 Тогда  	
				Проводим = Ложь;
			Иначе 
				Проводим = Истина;
			КонецЕсли;
		Иначе
			Проводим = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Если Проводим Тогда
		Если НЕ Отказ Тогда
			ПроводкиПоРегистрамЭлеватора(РежимПроведенияДокумента, СтруктураШапкиДокумента, ТаблицаПоКультурамВвозВывоз, Отказ, Заголовок);
		КонецЕсли;
	КонецЕсли;
		
КонецПроцедуры 

Процедура ПроводкиПоРегистрамЭлеватора(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоКультурамВвозВывоз, Отказ, Заголовок)
	
	ПроводитьККУ = ИНАГРО_Элеватор.ПроверкаЗаполненияКачества(Дата, ЛабораторныйАнализ, Влажность, Номенклатура);
	
	Если ВидОперации = Перечисления.ИНАГРО_ВидыОперацийРеестрТТНВывоз.ВывозОтходов Тогда 
		
		НеСписыватьОтходыСВладельцев = ИНАГРО_Элеватор.ПолучитьНастройкуНеСписыватьОтходыСВладельцев(ЭтотОбъект);		
		ВладелецДляОтходов           = ПараметрыУчетаЭлеватора.ВладелецДляОтходов;
		
		СтруктураШапкиДокумента.ВидДокумента = "ИНАГРО_Форма34Сводная";		
				
		СтруктураШапкиДокумента.Вставить("КодРасхода", ВернутьКодРасходаАктаОчисткиСушки(СтруктураШапкиДокумента.Отходы));
		
		Если НеСписыватьОтходыСВладельцев Тогда 
			
			ЧужойКонтрагент         = СтруктураШапкиДокумента.Владелец;
			ЧужойДоговорКонтрагента = СтруктураШапкиДокумента.ДоговорКонтрагента;	
			
			СтруктураШапкиДокумента.Владелец = ВладелецДляОтходов;
			
			Если ЗначениеЗаполнено(ВладелецДляОтходов) Тогда
				СтруктураШапкиДокумента.ДоговорКонтрагента = ВладелецДляОтходов.ОсновнойДоговорКонтрагента;
			Иначе
				СтруктураШапкиДокумента.ДоговорКонтрагента = "";
			КонецЕсли;				
			
			ИНАГРО_Элеватор.ДвиженияПоРегиструОстаткиРасход(Движения, СтруктураШапкиДокумента);
			ИНАГРО_Элеватор.ДвиженияПоРегиструОстаткиСводнаяРасход(Движения, СтруктураШапкиДокумента);
			
			Если ПроводитьККУ Тогда	
				ИНАГРО_Элеватор.ДвиженияПоРегиструФорма36Расход(Движения, СтруктураШапкиДокумента);
				ИНАГРО_Элеватор.ДвиженияПоРегиструФорма36СводнаяРасход(Движения, СтруктураШапкиДокумента);
			Иначе 
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Документ: %1 Не заполнены показатели качества, движения по форме 36 не выполнены!';uk='Документ: %1 Не заповнені показники якості, рухи за формою 36 не виконані!'"), Ссылка);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			КонецЕсли;
			
			СтруктураШапкиДокумента.Владелец           = ЧужойКонтрагент;
			СтруктураШапкиДокумента.ДоговорКонтрагента = ЧужойДоговорКонтрагента;
			
		Иначе
			
			КопияСтруктураШапкиДокумента = ИНАГРО_Элеватор.ПолучитьКопиюСтруктуры(СтруктураШапкиДокумента);
			
			ВидНоменклатуры = ИНАГРО_Элеватор.ПолучитьДополнительныйРеквизитНоменклатуры(КопияСтруктураШапкиДокумента.Номенклатура, "ВидТМЦ");
			
			Если ВидНоменклатуры = Перечисления.ИНАГРО_ВидыТМЦ.Кат3 Тогда
				КопияСтруктураШапкиДокумента.ДоговорКонтрагента = ИНАГРО_Элеватор.ПолучитьДополнительныйРеквизитОрганизации(Организация,"Договор",Дата);				
			КонецЕсли;
			
			ИНАГРО_Элеватор.ДвиженияПоРегиструОстаткиРасход(Движения, КопияСтруктураШапкиДокумента);
			ИНАГРО_Элеватор.ДвиженияПоРегиструОстаткиСводнаяРасход(Движения, СтруктураШапкиДокумента);
			
			Если ПроводитьККУ Тогда	
				
				ИНАГРО_Элеватор.ДвиженияПоРегиструФорма36Расход(Движения, КопияСтруктураШапкиДокумента);
				ИНАГРО_Элеватор.ДвиженияПоРегиструФорма36СводнаяРасход(Движения, СтруктураШапкиДокумента);
				
		        СтруктураШапкиДокумента.Вставить("НомерАнализа", НомерАнализа);
				
			Иначе 
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Документ: %1 Не заполнены показатели качества, движения по форме 36 не выполнены!';uk='Документ: %1 Не заповнені показники якості, рухи за формою 36 не виконані!'"), Ссылка);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		КопияСтруктураШапкиДокумента = ИНАГРО_Элеватор.ПолучитьКопиюСтруктуры(СтруктураШапкиДокумента);
		
		ВидНоменклатуры = ИНАГРО_Элеватор.ПолучитьДополнительныйРеквизитНоменклатуры(КопияСтруктураШапкиДокумента.Номенклатура, "ВидТМЦ");
		
		Если ВидНоменклатуры = Перечисления.ИНАГРО_ВидыТМЦ.Кат3 Тогда
			КопияСтруктураШапкиДокумента.ДоговорКонтрагента = ИНАГРО_Элеватор.ПолучитьДополнительныйРеквизитОрганизации(Организация,"Договор", Дата);				
		КонецЕсли; 
		
		ИНАГРО_Элеватор.ДвиженияПоРегиструОстаткиРасход(Движения, КопияСтруктураШапкиДокумента);
		ИНАГРО_Элеватор.ДвиженияПоРегиструОстаткиСводнаяРасход(Движения, СтруктураШапкиДокумента);
		
		Если ПроводитьККУ Тогда			
			ИНАГРО_Элеватор.ДвиженияПоРегиструФорма36Расход(Движения, КопияСтруктураШапкиДокумента);
			ИНАГРО_Элеватор.ДвиженияПоРегиструФорма36СводнаяРасход(Движения, СтруктураШапкиДокумента);			
		Иначе
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Документ: %1 Не заполнены показатели качества, движения по форме 36 не выполнены!';uk='Документ: %1 Не заповнені показники якості, рухи за формою 36 не виконані!'"), Ссылка);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		КонецЕсли;
		
	КонецЕсли;
	
	Если НЕ Отказ И ПараметрыУчетаЭлеватора.ОтражениеВвозаВывозаСобственногоЗернаВРегламентированномУчете Тогда
		ДвижениеПоРегиструКонтрольОтраженияВвозаВывозаСобственногоЗернаВРегламентированомУчете(РежимПроведенияДокумента, СтруктураШапкиДокумента, ТаблицаПоКультурамВвозВывоз, Отказ, Заголовок);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СтруктураШапкиДокумента.ЛабораторныйАнализ) Тогда
		ИНАГРО_Элеватор.ДвиженияПоРегиструЖурналЛабораторныхАнализов(Движения, СтруктураШапкиДокумента);
		ИНАГРО_Элеватор.ДвиженияПоРегиструФорма49(Движения, СтруктураШапкиДокумента);
	КонецЕсли;			
	
	Если НЕ Отказ Тогда
		
		ТаблицаУслуг = СформироватьТаблицуУслуг();
		
		Если ТаблицаУслуг.Количество() > 0  Тогда	
			ИНАГРО_Элеватор.ДвиженияПоРегиструРасчетыПоУслугам(Движения, ТаблицаУслуг, "Приход");
		КонецЕсли;
		
		ПровестиПоРегиструДанныеПоКачествуПартийЗерна();
		
	КонецЕсли;

	
КонецПроцедуры

Процедура ДвижениеПоРегиструКонтрольОтраженияВвозаВывозаСобственногоЗернаВРегламентированомУчете(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоТоварам, Отказ, Заголовок)
	
	ВыполнитьДвижения = Ложь;	
		
	Если СобственноеПодразделение И Владелец <> Получатель Тогда		
		ВыполнитьДвижения = Истина		
	КонецЕсли;
	
	Если ВыполнитьДвижения Тогда
		
		// Приход
		
		НаборДвижений = Движения.ИНАГРО_КонтрольОтраженияВвозаВывозаСобственногоЗернаВРегламентированномУчете;
		
		СтруктТаблицДокумента = Новый Структура;
		СтруктТаблицДокумента.Вставить("ТаблицаПоТоварам", ТаблицаПоТоварам);
		
		ТаблицыДанныхДокумента = ИНАГРО_Общий.ЗагрузитьТаблицыДокументаВСтруктуру(НаборДвижений, СтруктТаблицДокумента);
		
		ИНАГРО_Общий.ЗаписатьТаблицыДокументаВРегистр(НаборДвижений, ВидДвиженияНакопления.Приход, ТаблицыДанныхДокумента, Дата);		
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПровестиПоРегиструДанныеПоКачествуПартийЗерна()
	
	// Подготовим таблицу для проведения по регистру "ИНАГРО_ДанныеПоКачествуПартийЗерна".
	ТаблицаПоПартиям = ПодготовитьТаблицуПоПартиям();
	 		
	// Движения по регистру ДанныеПоКачетсвуПартийЗерна
	Если ТаблицаПоПартиям <> Неопределено Тогда
		Если ПараметрыУчетаЭлеватора.ИспользоватьСистемуКонтроляКачестваПартийЗерна Тогда
			НаборДвижений                  = Движения.ИНАГРО_ДанныеПоКачествуПартийЗерна;
			ТаблицаДвижений                = НаборДвижений.Выгрузить();
			ОбщегоНазначенияБПВызовСервера.ЗагрузитьВТаблицуЗначений(ТаблицаПоПартиям, ТаблицаДвижений);
			НаборДвижений.мПериод          = Дата;
			НаборДвижений.мТаблицаДвижений = ТаблицаДвижений;
			Движения.ИНАГРО_ДанныеПоКачествуПартийЗерна.ВыполнитьДвижения();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОбновитьПараметрыУчетаЭлеватора()

	ПараметрыУчетаЭлеватора  = ИНАГРО_Элеватор.ПолучитьПараметрыУчетаЭлеватора(Дата);
	СобственноеПодразделение = ИНАГРО_Элеватор.ПолучитьДополнительныйРеквизитКонтрагента(Владелец, "СобственноеПодразделение");
		
КонецПроцедуры

Процедура ЗаполнитьУслуги() Экспорт
	
	ОбновитьПараметрыУчетаЭлеватора();

	Если    НеПереформировыватьАвтоматически
		ИЛИ ВидОперации = Перечисления.ИНАГРО_ВидыОперацийРеестрТТНВывоз.ВывозОтходов Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаУслуг = Новый ТаблицаЗначений;
	ТаблицаУслуг.Колонки.Добавить("Номенклатура");
	ТаблицаУслуг.Колонки.Добавить("Количество");
	ТаблицаУслуг.Колонки.Добавить("Сумма"); 
		 
	Если НЕ СобственноеПодразделение Тогда
		
		ВидКультурыДляРасчетаСтоимостиУслуги = ИНАГРО_Элеватор.ПолучитьДополнительныйРеквизитНоменклатуры(Номенклатура, "ВидКультуры").ВидКультурыДляРасчетаСтоимостиУслуги;	
		СпособРасчета                        = ПараметрыУчетаЭлеватора.СпособНачисленияОплатыЗаУслугуЛабАнализа; 
		
		Номенклатура_Анализ                  = ИНАГРО_Элеватор.ПолучитьПредопределеннуюНоменклатуру("Анализ");
		Номенклатура_Погрузка                = ИНАГРО_Элеватор.ПолучитьПредопределеннуюНоменклатуру("Погрузка");

		// лабораторный анализ
		Если НЕ ПараметрыУчетаЭлеватора.НеРассчитыватьУслугиЛабАнализаПриВывозе Тогда
			
			Если ЗначениеЗаполнено(ЛабораторныйАнализ) Тогда

				Если ЗначениеЗаполнено(Номенклатура_Анализ) Тогда  
					
					Если ЗачетныйВес <> 0 Тогда
						ТекущаяЦена = ИНАГРО_Элеватор.ПолучитьЦенуУслугиЭлеватора(Организация, Дата, Владелец, ДоговорКонтрагента, ВидКультурыДляРасчетаСтоимостиУслуги, Урожай, Номенклатура_Анализ);
					Иначе
						ТекущаяЦена = 0;
					КонецЕсли;
					
					Если    СпособРасчета = Перечисления.ИНАГРО_СпособыНачисленияОплатыЗаАнализ.ЗаЕдиницу
						ИЛИ СпособРасчета = Перечисления.ИНАГРО_СпособыНачисленияОплатыЗаАнализ.ПустаяСсылка() Тогда 
						КоличествоУслуги = 1;
					ИначеЕсли СпособРасчета = Перечисления.ИНАГРО_СпособыНачисленияОплатыЗаАнализ.ЗаТоннуЗачВеса Тогда 
						КоличествоУслуги = ЗачетныйВес / 1000;
					ИначеЕсли СпособРасчета = Перечисления.ИНАГРО_СпособыНачисленияОплатыЗаАнализ.ЗаТоннуФизВеса Тогда
						КоличествоУслуги = ОбщийФизическийВес / 1000;
					ИначеЕсли СпособРасчета = Перечисления.ИНАГРО_СпособыНачисленияОплатыЗаАнализ.Нет Тогда
						КоличествоУслуги = 0;
					КонецЕсли;					
										
					Если ТекущаяЦена <> 0 И КоличествоУслуги <> 0 Тогда 													 
						НоваяСтрока              = ТаблицаУслуг.Добавить();
						НоваяСтрока.Номенклатура = Номенклатура_Анализ;
						НоваяСтрока.Количество   = КоличествоУслуги;
						НоваяСтрока.Сумма        = НоваяСтрока.Количество * ТекущаяЦена;
					Иначе
						ПараметрыОтбора = Новый Структура;
						ПараметрыОтбора.Вставить("Номенклатура", Номенклатура_Анализ);
						НайденныеСтроки = Услуги.НайтиСтроки(ПараметрыОтбора);
						Для Каждого Строк_Усл Из НайденныеСтроки Цикл
							Услуги.Удалить(Строк_Усл);
						КонецЦикла;
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;	
	
		// отгрузка
				
		Если ЗначениеЗаполнено(Номенклатура_Погрузка) Тогда   
			
			ТекущаяЦена = ИНАГРО_Элеватор.ПолучитьЦенуУслугиЭлеватора(Организация, Дата, Владелец, ДоговорКонтрагента, ВидКультурыДляРасчетаСтоимостиУслуги, Урожай, Номенклатура_Погрузка);
			
			Если ТекущаяЦена <> 0 И ФизическийВес <> 0 Тогда 													 
				НоваяСтрока              = ТаблицаУслуг.Добавить();
				НоваяСтрока.Номенклатура = Номенклатура_Погрузка;
				НоваяСтрока.Количество   = ФизическийВес / 1000;
				НоваяСтрока.Сумма        = НоваяСтрока.Количество * ТекущаяЦена;
			Иначе
				ПараметрыОтбора = Новый Структура;
				ПараметрыОтбора.Вставить("Номенклатура", Номенклатура_Погрузка);
				НайденныеСтроки = Услуги.НайтиСтроки(ПараметрыОтбора);
				Для Каждого Строк_Усл Из НайденныеСтроки Цикл
					Услуги.Удалить(Строк_Усл);
				КонецЦикла;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
		
	ТаблицаУслуг.Свернуть("Номенклатура", "Количество, Сумма");
	Для Каждого Строка_Услуг Из ТаблицаУслуг Цикл
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("Номенклатура", Строка_Услуг.Номенклатура);
		НайденныеСтроки = Услуги.НайтиСтроки(ПараметрыОтбора);
		Если НайденныеСтроки.Количество() = 0 Тогда
			Если ЗначениеЗаполнено(Строка_Услуг.Номенклатура) Тогда
				НоваяСтрока              = Услуги.Добавить();
				НоваяСтрока.Номенклатура = Строка_Услуг.Номенклатура;
				НоваяСтрока.Количество   = Строка_Услуг.Количество;
				НоваяСтрока.Цена         = Строка_Услуг.Сумма / Строка_Услуг.Количество;
				НоваяСтрока.Сумма        = Строка_Услуг.Сумма;
			КонецЕсли;
		Иначе
			Для каждого Строк_Усл Из НайденныеСтроки Цикл
				Строк_Усл.Количество = Строка_Услуг.Количество;
				Строк_Усл.Цена       = Строка_Услуг.Сумма / Строка_Услуг.Количество;
				Строк_Усл.Сумма      = Строка_Услуг.Сумма;
				Прервать;
			КонецЦикла;	
		КонецЕсли;	
	КонецЦикла;	
	
КонецПроцедуры

Функция СформироватьТаблицуУслуг()
	
	ТаблицаУслуг = Новый ТаблицаЗначений;
	ТаблицаУслуг.Колонки.Добавить("ДатаРасчета");
	ТаблицаУслуг.Колонки.Добавить("Ссылка"); 
	ТаблицаУслуг.Колонки.Добавить("Организация");
	ТаблицаУслуг.Колонки.Добавить("Контрагент");
	ТаблицаУслуг.Колонки.Добавить("ДоговорКонтрагента");
	ТаблицаУслуг.Колонки.Добавить("Номенклатура");
	ТаблицаУслуг.Колонки.Добавить("Культура");
	ТаблицаУслуг.Колонки.Добавить("Склад");
	ТаблицаУслуг.Колонки.Добавить("ВидХранения");
	ТаблицаУслуг.Колонки.Добавить("Урожай");
	ТаблицаУслуг.Колонки.Добавить("Количество");
	ТаблицаУслуг.Колонки.Добавить("Стоимость");  
	
	Для каждого СтрокаТабУслуги Из Услуги Цикл
		НоваяСтрока                    = ТаблицаУслуг.Добавить();
		НоваяСтрока.ДатаРасчета        = Дата;
		НоваяСтрока.Ссылка             = Ссылка; 
		НоваяСтрока.Организация        = Организация;
		НоваяСтрока.Контрагент         = Владелец;
		НоваяСтрока.ДоговорКонтрагента = ДоговорКонтрагента;
		НоваяСтрока.Номенклатура       = СтрокаТабУслуги.Номенклатура;
		НоваяСтрока.Культура           = Номенклатура;
		НоваяСтрока.Склад              = Склад;
		НоваяСтрока.ВидХранения        = ВидХранения;
		НоваяСтрока.Урожай             = Урожай;
		НоваяСтрока.Количество         = СтрокаТабУслуги.Количество;
		НоваяСтрока.Стоимость          = СтрокаТабУслуги.Сумма;	
	КонецЦикла;	
	
	Возврат ТаблицаУслуг;
	
КонецФункции

Функция ПодготовитьТаблицуПоПартиям()
	
	РезТаблица = Неопределено;
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("МоментВремени"      , МоментВремени());
	Запрос.УстановитьПараметр("Организация"        , Организация);
	Запрос.УстановитьПараметр("Контрагент"         , Владелец);
	Запрос.УстановитьПараметр("ДоговорКонтрагента" , ДоговорКонтрагента);
	Запрос.УстановитьПараметр("Номенклатура"       , Номенклатура);
	Запрос.УстановитьПараметр("Склад"              , Склад);
	Запрос.УстановитьПараметр("ВидХранения"        , ВидХранения);
	Запрос.УстановитьПараметр("Урожай"             , Урожай);
	
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТаблицаРегистра.*
		|ИЗ
		|	РегистрСведений.ИНАГРО_ДанныеПоКачествуПартийЗерна.СрезПоследних(
		|			&МоментВремени,
		|			Организация = &Организация
		|				И Контрагент = &Контрагент
		|				И ДоговорКонтрагента = &ДоговорКонтрагента
		|				И Номенклатура = &Номенклатура
		|				И Склад = &Склад
		|				И ВидХранения = &ВидХранения
		|				И Урожай = &Урожай) КАК ТаблицаРегистра
		|
		|УПОРЯДОЧИТЬ ПО
		|	ТаблицаРегистра.ПартияЗерна.Дата";
	
	ТаблицаРезультатаЗапроса = Запрос.Выполнить().Выгрузить();			   
	
	Если ТаблицаРезультатаЗапроса.Количество() > 0 Тогда 
		
		РезТаблица = ТаблицаРезультатаЗапроса.Скопировать();
		РезТаблица.Очистить();
		
		ОбщийВесПереоформления = СписокТТН.Итог("Вес");
		Для Каждого СтрокаПартии Из ТаблицаРезультатаЗапроса Цикл
			Если ОбщийВесПереоформления > 0 Тогда
				ОстатокПартии = СтрокаПартии.ФизическийВесИтоговый - СтрокаПартии.Вывезено;
				Если ОстатокПартии > 0 Тогда
					НоваяСтрока = РезТаблица.Добавить();
					ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаПартии);
					НоваяСтрока.Вывезено   = СтрокаПартии.Вывезено + МИН(ОстатокПартии, ОбщийВесПереоформления);
					ОбщийВесПереоформления = ОбщийВесПереоформления - МИН(ОстатокПартии, ОбщийВесПереоформления);
				КонецЕсли;	
			КонецЕсли;
		КонецЦикла;	
		
		Если РезТаблица.Количество() = 0 Тогда
			РезТаблица = Неопределено;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат РезТаблица;
	
КонецФункции	

Функция ВернутьКодРасходаАктаОчисткиСушки(Культура)
	
	КодРасходаАктаОчисткиСушки = Перечисления.ИНАГРО_КодыРасхода.Культура;
	ВидТМЦ                     = ИНАГРО_Элеватор.ПолучитьДополнительныйРеквизитНоменклатуры(Культура, "ВидТМЦ");
	
	Если ВидТМЦ = Перечисления.ИНАГРО_ВидыТМЦ.Побочный Тогда
		КодРасходаАктаОчисткиСушки = Перечисления.ИНАГРО_КодыРасхода.Побочный;
	ИначеЕсли ВидТМЦ=Перечисления.ИНАГРО_ВидыТМЦ.Кат1 Тогда
		КодРасходаАктаОчисткиСушки = Перечисления.ИНАГРО_КодыРасхода.Кат1;
	ИначеЕсли ВидТМЦ=Перечисления.ИНАГРО_ВидыТМЦ.Кат2 Тогда
		КодРасходаАктаОчисткиСушки = Перечисления.ИНАГРО_КодыРасхода.Кат2;
	ИначеЕсли ВидТМЦ = Перечисления.ИНАГРО_ВидыТМЦ.Кат3 Тогда
		КодРасходаАктаОчисткиСушки = Перечисления.ИНАГРО_КодыРасхода.Кат3;
	КонецЕсли;
	
	Возврат КодРасходаАктаОчисткиСушки;
	
КонецФункции

Функция ПолучитьПараметрыДляРасчетаЗачетногоВеса()
	
	ПараметрыДляРасчетаЗачетногоВеса = Новый Структура(
		"Ссылка, Дата, Организация,
		|Владелец, ДоговорКонтрагента, Номенклатура,
		|Склад, Влажность, СорнаяПримесь,
		|ФизическийВес, ЗачетныйВес     
		|");
	ЗаполнитьЗначенияСвойств(ПараметрыДляРасчетаЗачетногоВеса, ЭтотОбъект);
	
	Возврат ПараметрыДляРасчетаЗачетногоВеса;
	
КонецФункции

#КонецОбласти

#КонецЕсли