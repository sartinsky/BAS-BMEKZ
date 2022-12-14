#Область ПрограммныйИнтерфейс

// Определяет объекты конфигурации, в модулях менеджеров которых размещена процедура ДобавитьКомандыПечати,
// формирующая список команд печати, предоставляемых этим объектом.
// Синтаксис процедуры ДобавитьКомандыПечати см. в документации к подсистеме.
//
// Параметры:
//  СписокОбъектов - Массив - менеджеры объектов с процедурой ДобавитьКомандыПечати.
//
Процедура ПриОпределенииОбъектовСКомандамиПечати(СписокОбъектов) Экспорт
	
	СписокОбъектов.Добавить(Справочники.БанковскиеСчета);
	СписокОбъектов.Добавить(Справочники.ДоговорыКонтрагентов);
	СписокОбъектов.Добавить(Справочники.Контрагенты);
	СписокОбъектов.Добавить(Справочники.КонтактныеЛица);
	СписокОбъектов.Добавить(Справочники.НематериальныеАктивы);
	СписокОбъектов.Добавить(Справочники.Номенклатура);
	СписокОбъектов.Добавить(Справочники.НоменклатурныеГруппы);
	СписокОбъектов.Добавить(Справочники.ОбъектыСтроительства);
	СписокОбъектов.Добавить(Справочники.Организации);
	СписокОбъектов.Добавить(Справочники.ОсновныеСредства);
	СписокОбъектов.Добавить(Справочники.ПодразделенияОрганизаций);
	СписокОбъектов.Добавить(Справочники.Склады);
	СписокОбъектов.Добавить(Справочники.СтатьиЗатрат);
	СписокОбъектов.Добавить(Справочники.Субконто);
	СписокОбъектов.Добавить(Справочники.ТиповыеОперации);
	СписокОбъектов.Добавить(Документы.АвансовыйОтчет);
	СписокОбъектов.Добавить(Документы.АктОбОказанииПроизводственныхУслуг);
	СписокОбъектов.Добавить(Документы.АктСверкиВзаиморасчетов);
	СписокОбъектов.Добавить(Документы.ВводВЭксплуатациюОС);
	СписокОбъектов.Добавить(Документы.ВводНачальныхОстатков);
	СписокОбъектов.Добавить(Документы.ВводСведенийОбИндексированномДоходе);
	СписокОбъектов.Добавить(Документы.ВозвратТоваровОтПокупателя);
	СписокОбъектов.Добавить(Документы.ВозвратТоваровПоставщику);
	СписокОбъектов.Добавить(Документы.ВыработкаНМА);
	СписокОбъектов.Добавить(Документы.ВыработкаОС);
	СписокОбъектов.Добавить(Документы.ГТДИмпорт);
	СписокОбъектов.Добавить(Документы.Доверенность);
	СписокОбъектов.Добавить(Документы.ДокументРасчетовСКонтрагентом);
	СписокОбъектов.Добавить(Документы.ЗакрытиеМесяца);
	СписокОбъектов.Добавить(Документы.ЗаявкаНаПокупкуПродажуВалюты);
	СписокОбъектов.Добавить(Документы.ИзменениеГрафиковАмортизацииОС);
	СписокОбъектов.Добавить(Документы.ИзменениеНалоговогоНазначенияЗапасов);
	СписокОбъектов.Добавить(Документы.ИзменениеНалоговогоНазначенияОС);
	СписокОбъектов.Добавить(Документы.ИзменениеНалоговогоНазначенияТЗР);
	СписокОбъектов.Добавить(Документы.ИзменениеПараметровНачисленияАмортизацииНМА);
	СписокОбъектов.Добавить(Документы.ИзменениеПараметровНачисленияАмортизацииОС);
	СписокОбъектов.Добавить(Документы.ИзменениеСостоянияОС);
	СписокОбъектов.Добавить(Документы.ИзменениеСпособовОтраженияРасходовПоАмортизацииНМА);
	СписокОбъектов.Добавить(Документы.ИзменениеСпособовОтраженияРасходовПоАмортизацииОС);
	СписокОбъектов.Добавить(Документы.ИнвентаризацияНЗП);
	СписокОбъектов.Добавить(Документы.ИнвентаризацияНМА);
	СписокОбъектов.Добавить(Документы.ИнвентаризацияОС);
	СписокОбъектов.Добавить(Документы.ИнвентаризацияРасчетовСКонтрагентами);
	СписокОбъектов.Добавить(Документы.ИнвентаризацияТоваровНаСкладе);
	СписокОбъектов.Добавить(Документы.ИндексацияОС);
	СписокОбъектов.Добавить(Документы.КомплектацияНоменклатуры);
	СписокОбъектов.Добавить(Документы.КорректировкаДолга);
	СписокОбъектов.Добавить(Документы.КорректировкаОжидаемогоИПодтвержденногоНДС);
	СписокОбъектов.Добавить(Документы.МодернизацияНМА);
	СписокОбъектов.Добавить(Документы.МодернизацияОС);
	СписокОбъектов.Добавить(Документы.НалоговаяНакладная);
	СписокОбъектов.Добавить(Документы.НормированиеРасходовПоНалогуНаПрибыль);
	СписокОбъектов.Добавить(Документы.ОперацияБух);
	СписокОбъектов.Добавить(Документы.ОпределениеФинансовыхРезультатов);
	СписокОбъектов.Добавить(Документы.ОприходованиеТоваров);
	СписокОбъектов.Добавить(Документы.ОтражениеЗарплатыВУчете);
	СписокОбъектов.Добавить(Документы.ОтчетКомиссионераОПродажах);
	СписокОбъектов.Добавить(Документы.ОтчетКомитентуОПродажах);
	СписокОбъектов.Добавить(Документы.ОтчетОРозничныхПродажах);
	СписокОбъектов.Добавить(Документы.ОтчетПроизводстваЗаСмену);
	СписокОбъектов.Добавить(Документы.Партия);
	СписокОбъектов.Добавить(Документы.ПартияМалоценныхАктивовВЭксплуатации);
	СписокОбъектов.Добавить(Документы.ПередачаМалоценныхАктивовВЭксплуатацию);
	СписокОбъектов.Добавить(Документы.ПередачаНМА);
	СписокОбъектов.Добавить(Документы.ПередачаОборудованияВМонтаж);
	СписокОбъектов.Добавить(Документы.ПередачаОС);
	СписокОбъектов.Добавить(Документы.ПередачаТоваров);
	СписокОбъектов.Добавить(Документы.ПеремещениеМалоценныхАктивовВЭксплуатации);
	СписокОбъектов.Добавить(Документы.ПеремещениеНМА);
	СписокОбъектов.Добавить(Документы.ПеремещениеОС);
	СписокОбъектов.Добавить(Документы.ПеремещениеТоваров);
	СписокОбъектов.Добавить(Документы.ПереоценкаОС);
	СписокОбъектов.Добавить(Документы.ПереоценкаТоваровВРознице);
	СписокОбъектов.Добавить(Документы.ПерерасчетПропорциональногоНДСпоТоварамИОС);
	СписокОбъектов.Добавить(Документы.ПлатежноеПоручение);
	СписокОбъектов.Добавить(Документы.ПодготовкаКПередачеОС);
	СписокОбъектов.Добавить(Документы.ПокупкаПродажаВалюты);
	СписокОбъектов.Добавить(Документы.ПоступлениеДопРасходов);
	СписокОбъектов.Добавить(Документы.ПоступлениеИзПереработки);
	СписокОбъектов.Добавить(Документы.ПоступлениеНаРасчетныйСчет);
	СписокОбъектов.Добавить(Документы.ПоступлениеНМА);
	СписокОбъектов.Добавить(Документы.ПоступлениеТоваровУслуг);
	СписокОбъектов.Добавить(Документы.Приложение1КНалоговойНакладной);
	СписокОбъектов.Добавить(Документы.Приложение2КНалоговойНакладной);
	СписокОбъектов.Добавить(Документы.ПринятиеКУчетуНМА);
	СписокОбъектов.Добавить(Документы.ПриходныйКассовыйОрдер);
	СписокОбъектов.Добавить(Документы.РасходныйКассовыйОрдер);
	СписокОбъектов.Добавить(Документы.РасчетыПоНалогуНаПрибыль);
	СписокОбъектов.Добавить(Документы.РеализацияТоваровУслуг);
	СписокОбъектов.Добавить(Документы.РеализацияУслугПоПереработке);
	СписокОбъектов.Добавить(Документы.РегистрацияАвансовВНалоговомУчете);
	СписокОбъектов.Добавить(Документы.РегистрацияВходящегоНалоговогоДокумента);
	СписокОбъектов.Добавить(Документы.РегистрацияСтоимостиПриобретенияОСПропорциональноОблагаемыхНДС);
	СписокОбъектов.Добавить(Документы.СписаниеМалоценныхАктивовИзЭксплуатации);
	СписокОбъектов.Добавить(Документы.СписаниеНМА);
	СписокОбъектов.Добавить(Документы.СписаниеОС);
	СписокОбъектов.Добавить(Документы.СписаниеСРасчетногоСчета);
	СписокОбъектов.Добавить(Документы.СписаниеТоваров);
	СписокОбъектов.Добавить(Документы.СчетНаОплатуПокупателю);
	СписокОбъектов.Добавить(Документы.СчетНаОплатуПоставщика);
	СписокОбъектов.Добавить(Документы.ТребованиеНакладная);
	СписокОбъектов.Добавить(Документы.УстановкаГарантийныхСроковНалоговыйУчет);
	СписокОбъектов.Добавить(Документы.УстановкаКоэффициентаПропорциональногоОтнесенияНДСНаКредит);
	СписокОбъектов.Добавить(Документы.УстановкаПорядкаЗакрытияПодразделений);
	СписокОбъектов.Добавить(Документы.УстановкаЦенНоменклатуры);
		
	СписокОбъектов.Добавить(ЖурналыДокументов.Деньги);
	СписокОбъектов.Добавить(ЖурналыДокументов.ДокументыПоМалоценнымАктивам);
	СписокОбъектов.Добавить(ЖурналыДокументов.ДокументыПоНМА);
	СписокОбъектов.Добавить(ЖурналыДокументов.ДокументыПоОС);
	СписокОбъектов.Добавить(ЖурналыДокументов.ЖурналОпераций);
	СписокОбъектов.Добавить(ЖурналыДокументов.ПроизводственныеДокументы);
	СписокОбъектов.Добавить(ЖурналыДокументов.СкладскиеДокументы);
	
	// ИНАГРО++
	
	//СписокОбъектов.Добавить(Справочники.ИНАГРО_ГрафикиРаботы);	
	СписокОбъектов.Добавить(Документы.ИНАГРО_БригадныйНаряд);
	СписокОбъектов.Добавить(Документы.ИНАГРО_ВводНачальныхОстатковТоплива);
	СписокОбъектов.Добавить(Документы.ИНАГРО_ВводСведенийОБанковскихКарточкахРаботников);
	СписокОбъектов.Добавить(Документы.ИНАГРО_ВедомостьРеализация);
	СписокОбъектов.Добавить(Документы.ИНАГРО_ДоговорНаВыполнениеРаботСФизЛицом);
	СписокОбъектов.Добавить(Документы.ИНАГРО_ЗаменыРаботниковОрганизаций);
	СписокОбъектов.Добавить(Документы.ИНАГРО_ЗарплатаКВыплатеОрганизаций);
	СписокОбъектов.Добавить(Документы.ИНАГРО_ИнвентаризацияАрендованныхОС);
	СписокОбъектов.Добавить(Документы.ИНАГРО_ИнвентаризацияОС); 	
	СписокОбъектов.Добавить(Документы.ИНАГРО_КадровоеПеремещениеОрганизаций);
	СписокОбъектов.Добавить(Документы.ИНАГРО_КорректировкаЗатрат);
	СписокОбъектов.Добавить(Документы.ИНАГРО_КорректировкаИспользованияРаботникамиРабочегоВремени);	
	СписокОбъектов.Добавить(Документы.ИНАГРО_НачислениеЗарплатыРаботникамОрганизаций);
	СписокОбъектов.Добавить(Документы.ИНАГРО_НачислениеОтпускаРаботникамОрганизаций);    
	СписокОбъектов.Добавить(Документы.ИНАГРО_РегистрацияПростояРаботниковОрганизаций);
	СписокОбъектов.Добавить(Документы.ИНАГРО_НачислениеПоБольничномуЛисту);
	СписокОбъектов.Добавить(Документы.ИНАГРО_ОплатаПоСреднемуЗаработку);
	СписокОбъектов.Добавить(Документы.ИНАГРО_ОплатаПраздничныхИВыходныхДнейОрганизаций);
	СписокОбъектов.Добавить(Документы.ИНАГРО_ПодтверждениеВыплатФСС);
	СписокОбъектов.Добавить(Документы.ИНАГРО_ПриемНаРаботуВОрганизацию);
	СписокОбъектов.Добавить(Документы.ИНАГРО_ПриходныйОрдерНаТовары);
	СписокОбъектов.Добавить(Документы.ИНАГРО_ПрочиеЗатраты);
	СписокОбъектов.Добавить(Документы.ИНАГРО_ПутевойЛистГрузовогоАвтомобиля);
	СписокОбъектов.Добавить(Документы.ИНАГРО_ПутевойЛистТрактористаМашиниста);
	СписокОбъектов.Добавить(Документы.ИНАГРО_РаспределениеЗатрат);	
	СписокОбъектов.Добавить(Документы.ИНАГРО_РасходныйОрдерНаТовары);
	СписокОбъектов.Добавить(Документы.ИНАГРО_РасчетКорректировкиЦены);
	СписокОбъектов.Добавить(Документы.ИНАГРО_СдельныйНаряд);
	СписокОбъектов.Добавить(Документы.ИНАГРО_СправкаОДоходах);
	СписокОбъектов.Добавить(Документы.ИНАГРО_УвольнениеИзОрганизаций);
	СписокОбъектов.Добавить(Документы.ИНАГРО_ЗаявлениеРасчетВФСС);
	СписокОбъектов.Добавить(Документы.ИНАГРО_ИнвентаризацияМЦ);
	СписокОбъектов.Добавить(Документы.ИНАГРО_ТабельУчетаРабочегоВремениОрганизации);
	СписокОбъектов.Добавить(Документы.ИНАГРО_ИзменениеШтатногоРасписанияОрганизаций);
	СписокОбъектов.Добавить(Документы.ИНАГРО_УчетАрендованныхОС);
	
	Если ИНАГРО_ОбщийВызовСервераПовтИсп.ЕстьБСПУ() Тогда
		
		СписокОбъектов.Добавить(Документы.ИНАГРО_АктПереоценкиБиологическихАктивов);
		СписокОбъектов.Добавить(Документы.ИНАГРО_АвансовыйОтчет);	
		СписокОбъектов.Добавить(Документы.ИНАГРО_АктПриемаПередачи);
		СписокОбъектов.Добавить(Документы.ИНАГРО_ВедомостьВыплатПайщикам);
		СписокОбъектов.Добавить(Документы.ИНАГРО_ВедомостьРеализацияБиологическихАктивов);
		СписокОбъектов.Добавить(Документы.ИНАГРО_ВозвратБиологическихАктивовОтПокупателя);
		СписокОбъектов.Добавить(Документы.ИНАГРО_ВозвратБиологическихАктивовПоставщику);
		СписокОбъектов.Добавить(Документы.ИНАГРО_ГТДИмпортБиологическихАктивов);
		СписокОбъектов.Добавить(Документы.ИНАГРО_Забой);
		СписокОбъектов.Добавить(Документы.ИНАГРО_ЗакладкаВИнкубаторий);
		СписокОбъектов.Добавить(Документы.ИНАГРО_ИнвентаризацияАрендованныхБА);
		СписокОбъектов.Добавить(Документы.ИНАГРО_ИнвентаризацияБА);
		СписокОбъектов.Добавить(Документы.ИНАГРО_ЛимитноЗаборнаяКарта);
		СписокОбъектов.Добавить(Документы.ИНАГРО_НачислениеДругихВыплат);
		СписокОбъектов.Добавить(Документы.ИНАГРО_НачислениеПоПаям);
		СписокОбъектов.Добавить(Документы.ИНАГРО_ОприходованиеБиологическихАктивов);
		СписокОбъектов.Добавить(Документы.ИНАГРО_ОприходованиеНезавершенкиРастениеводства);
		СписокОбъектов.Добавить(Документы.ИНАГРО_ОтражениеОтходовРастениеводства);
		СписокОбъектов.Добавить(Документы.ИНАГРО_ОтчетОВыходеИнкубатория);
		СписокОбъектов.Добавить(Документы.ИНАГРО_ПеремещениеБиологическихАктивов);
		СписокОбъектов.Добавить(Документы.ИНАГРО_ПоступлениеБиологическихАктивов);
		СписокОбъектов.Добавить(Документы.ИНАГРО_ПриплодИПривес);		
		СписокОбъектов.Добавить(Документы.ИНАГРО_РеализацияБиологическихАктивов);
		СписокОбъектов.Добавить(Документы.ИНАГРО_РеализацияКоммунальныхУслуг);
		СписокОбъектов.Добавить(Документы.ИНАГРО_СписаниеБиологическихАктивов);
		СписокОбъектов.Добавить(Документы.ИНАГРО_СправкаОДоходахПайщика);
		СписокОбъектов.Добавить(Документы.ИНАГРО_УстановкаЦенБиологическихАктивов);
		СписокОбъектов.Добавить(Документы.ИНАГРО_СчетНаОплатуПокупателюБиологическихАктивов);	
		СписокОбъектов.Добавить(Документы.ИНАГРО_СчетНаОплатуПоставщикаБиологическихАктивов);
		СписокОбъектов.Добавить(Документы.ИНАГРО_РегистрацияРазовыхНачисленийРаботниковОрганизаций);
		
	КонецЕсли;	
	
	Если ИНАГРО_ОбщийВызовСервераПовтИсп.ЕстьБЭМКЗУ() Тогда
		
		СписокОбъектов.Добавить(Документы.ИНАГРО_АктЗачистки);
		СписокОбъектов.Добавить(Документы.ИНАГРО_АктРаспределения);
		СписокОбъектов.Добавить(Документы.ИНАГРО_АктРасчет310);
		СписокОбъектов.Добавить(Документы.ИНАГРО_АктСписания);
		СписокОбъектов.Добавить(Документы.ИНАГРО_АктУничтоженияНегодныхОтходов);
		СписокОбъектов.Добавить(Документы.ИНАГРО_АктФасовки);
		СписокОбъектов.Добавить(Документы.ИНАГРО_ВедомостьОтвесов);
		СписокОбъектов.Добавить(Документы.ИНАГРО_Взвешивание);
		СписокОбъектов.Добавить(Документы.ИНАГРО_Инвентаризация);
		СписокОбъектов.Добавить(Документы.ИНАГРО_Корректировка);
		СписокОбъектов.Добавить(Документы.ИНАГРО_КорректировкаСписком);
		СписокОбъектов.Добавить(Документы.ИНАГРО_КорректировкаУслуг);
		СписокОбъектов.Добавить(Документы.ИНАГРО_ЛабораторныйАнализ);
		СписокОбъектов.Добавить(Документы.ИНАГРО_НаблюдениеСостоянияЗерна);
		СписокОбъектов.Добавить(Документы.ИНАГРО_ОтражениеВвозаВывозаСобственногоЗернаВРегламентированномУчете);		
		СписокОбъектов.Добавить(Документы.ИНАГРО_Перемещение);
		СписокОбъектов.Добавить(Документы.ИНАГРО_Переоформление);
		СписокОбъектов.Добавить(Документы.ИНАГРО_Переработка);
		СписокОбъектов.Добавить(Документы.ИНАГРО_ПриказНаВывоз);
		СписокОбъектов.Добавить(Документы.ИНАГРО_ПриказНаПеремещение);
		СписокОбъектов.Добавить(Документы.ИНАГРО_ПриходИзПроизводства);
		СписокОбъектов.Добавить(Документы.ИНАГРО_РасчетУслуг);
		СписокОбъектов.Добавить(Документы.ИНАГРО_РасчетУслугХранения);
		СписокОбъектов.Добавить(Документы.ИНАГРО_РасчетыСВладельцем);
		СписокОбъектов.Добавить(Документы.ИНАГРО_РеестрТТНВвоз);
		СписокОбъектов.Добавить(Документы.ИНАГРО_РеестрТТНВвозЖД);
		СписокОбъектов.Добавить(Документы.ИНАГРО_РеестрТТНВнутр);
		СписокОбъектов.Добавить(Документы.ИНАГРО_РеестрТТНВывоз);
		СписокОбъектов.Добавить(Документы.ИНАГРО_РеестрТТНВывозЖД);
		СписокОбъектов.Добавить(Документы.ИНАГРО_Рецепт);
		СписокОбъектов.Добавить(Документы.ИНАГРО_СвидетельствоОКачествеЗерна);		
		СписокОбъектов.Добавить(Документы.ИНАГРО_СкладскаяКвитанция);
		СписокОбъектов.Добавить(Документы.ИНАГРО_СкладскаяКвитанцияДвойная);
		СписокОбъектов.Добавить(Документы.ИНАГРО_СкладскаяКвитанцияПростая);		
		СписокОбъектов.Добавить(Документы.ИНАГРО_ТТНВвоз);
		СписокОбъектов.Добавить(Документы.ИНАГРО_ТТНВвозЖД);
		СписокОбъектов.Добавить(Документы.ИНАГРО_ТТНВнутр);
		СписокОбъектов.Добавить(Документы.ИНАГРО_ТТНВывоз);
		СписокОбъектов.Добавить(Документы.ИНАГРО_ТТНВывозЖД);		
		СписокОбъектов.Добавить(Документы.ИНАГРО_УстановкаЦенНаУслуги);		
		СписокОбъектов.Добавить(Документы.ИНАГРО_Форма117);	
		СписокОбъектов.Добавить(Документы.ИНАГРО_Форма34Сводная);
		
		СписокОбъектов.Добавить(ЖурналыДокументов.ИНАГРО_Корректировки);
		СписокОбъектов.Добавить(ЖурналыДокументов.ИНАГРО_РеестрыТоварноТранспортныхНакладных);
		СписокОбъектов.Добавить(ЖурналыДокументов.ИНАГРО_РеестрыТоварноТранспортныхНакладныхЖД);
		СписокОбъектов.Добавить(ЖурналыДокументов.ИНАГРО_СкладскиеКвитанции);
		СписокОбъектов.Добавить(ЖурналыДокументов.ИНАГРО_ТоварноТранспортныеНакладные);
		СписокОбъектов.Добавить(ЖурналыДокументов.ИНАГРО_ТоварноТранспортныеНакладныеЖД);
		
	КонецЕсли;
	
	// ИНАГРО--
	
	ЗарплатаКадры.ПриОпределенииОбъектовСКомандамиПечати(СписокОбъектов);	
	
КонецПроцедуры

// Переопределяет таблицу возможных форматов для сохранения табличного документа.
// Используется в случае, когда необходимо сократить список форматов сохранения, предлагаемый пользователю
// перед сохранением печатной формы в файл, либо перед отправкой по почте.
//
// Параметры:
//  ТаблицаФорматов - ТаблицаЗначений - коллекция форматов сохранения:
//   * ТипФайлаТабличногоДокумента - ТипФайлаТабличногоДокумента - значение в платформе, соответствующее формату;
//   * Ссылка        - ПеречислениеСсылка.ФорматыСохраненияОтчетов - ссылка на метаданные, где хранится представление;
//   * Представление - Строка - представление типа файла (заполняется из перечисления);
//   * Расширение    - Строка - тип файла для операционной системы;
//   * Картинка      - Картинка - значок формата.
//
Процедура ПриЗаполненииНастроекФорматовСохраненияТабличногоДокумента(ТаблицаФорматов) Экспорт
	
КонецПроцедуры

// Переопределяет список команд печати, получаемый функцией УправлениеПечатью.КомандыПечатиФормы.
// Используется для общих форм, у которых нет модуля менеджера для размещения в нем процедуры ДобавитьКомандыПечати,
// для случаев, когда штатных средств добавления команд в такие формы недостаточно. Например, если нужны свои команды,
// которых нет в других объектах.
// 
// Параметры:
//  ИмяФормы             - Строка - полное имя формы, в которой добавляются команды печати;
//  КомандыПечати        - ТаблицаЗначений - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати;
//  СтандартнаяОбработка - Булево - при установке значения Ложь не будет автоматически заполняться коллекция КомандыПечати.
//
Процедура ПередДобавлениемКомандПечати(ИмяФормы, КомандыПечати, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Дополнительные настройки списка команд печати в журналах документов.
//
// Параметры:
//  НастройкиСписка - Структура - модификаторы списка команд печати.
//   * МенеджерКомандПечати     - МенеджерОбъекта - менеджер объекта, в котором формируется список команд печати;
//   * АвтоматическоеЗаполнение - Булево - заполнять команды печати из объектов, входящих в состав журнала.
//                                         Если установлено значение Ложь, то список команд печати журнала будет
//                                         заполнен вызовом метода ДобавитьКомандыПечати из модуля менеджера журнала.
//                                         Значение по умолчанию: Истина - метод ДобавитьКомандыПечати будет вызван из
//                                         модулей менеджеров документов, входящих в состав журнала.
Процедура ПриПолученииНастроекСпискаКомандПечати(НастройкиСписка) Экспорт
	
	Если НастройкиСписка.МенеджерКомандПечати = ЖурналыДокументов.Деньги	
		Или НастройкиСписка.МенеджерКомандПечати = ЖурналыДокументов.ДокументыПоМалоценнымАктивам
		Или НастройкиСписка.МенеджерКомандПечати = ЖурналыДокументов.ДокументыПоНМА
		Или НастройкиСписка.МенеджерКомандПечати = ЖурналыДокументов.ДокументыПоОС
		Или НастройкиСписка.МенеджерКомандПечати = ЖурналыДокументов.ЖурналОпераций
		Или НастройкиСписка.МенеджерКомандПечати = ЖурналыДокументов.ПроизводственныеДокументы
		Или НастройкиСписка.МенеджерКомандПечати = ЖурналыДокументов.СкладскиеДокументы Тогда    
		НастройкиСписка.АвтоматическоеЗаполнение = Ложь;
	КонецЕсли;
	
	// ИНАГРО++
	Если ИНАГРО_ОбщийВызовСервераПовтИсп.ЕстьБЭМКЗУ() Тогда
		Если НастройкиСписка.МенеджерКомандПечати = ЖурналыДокументов.ИНАГРО_Корректировки
			Или НастройкиСписка.МенеджерКомандПечати = ЖурналыДокументов.ИНАГРО_РеестрыТоварноТранспортныхНакладных
			Или НастройкиСписка.МенеджерКомандПечати = ЖурналыДокументов.ИНАГРО_РеестрыТоварноТранспортныхНакладныхЖД
			Или НастройкиСписка.МенеджерКомандПечати = ЖурналыДокументов.ИНАГРО_СкладскиеКвитанции
			Или НастройкиСписка.МенеджерКомандПечати = ЖурналыДокументов.ИНАГРО_ТоварноТранспортныеНакладные  
			Или НастройкиСписка.МенеджерКомандПечати = ЖурналыДокументов.ИНАГРО_ТоварноТранспортныеНакладныеЖД Тогда
			НастройкиСписка.АвтоматическоеЗаполнение = Ложь;
		КонецЕсли;
	КонецЕсли;
	// ИНАГРО--
	
//++ БУ ЗИК	
	ЗарплатаКадры.ПриПолученииНастроекСпискаКомандПечати(НастройкиСписка);
//-- БУ ЗИК	
	
КонецПроцедуры

// Вызывается после завершения вызова процедуры Печать менеджера печати объекта, имеет те же параметры.
// Может использоваться для постобработки всех печатных форм при их формировании.
// Например, можно вставить в колонтитул дату формирования печатной формы.
//
// Параметры:
//  МассивОбъектов - Массив - список объектов, для которых была выполнена процедура Печать;
//  ПараметрыПечати - Структура - произвольные параметры, переданные при вызове команды печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - содержит табличные документы и дополнительную информацию;
//  ОбъектыПечати - СписокЗначений - соответствие между объектами и именами областей в табличных документах, где
//                                   значение - Объект, представление - имя области с объектом в табличных документах;
//  ПараметрыВывода - Структура - параметры, связанные с выводом табличных документов:
//   * ПараметрыОтправки - Структура - информация для заполнения письма при отправке печатной формы по электронной почте.
//                                     Содержит следующие поля (описание см. в общем модуле конфигурации
//                                     РаботаСПочтовымиСообщениямиКлиент в процедуре СоздатьНовоеПисьмо):
//    ** Получатель;
//    ** Тема,
//    ** Текст.
Процедура ПриПечати(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	
	
КонецПроцедуры

// Переопределяет параметры отправки печатных форм при подготовке письма.
// Может использоваться, например, для подготовки текста письма.
//
// Параметры:
//  ПараметрыОтправки - Структура - коллекция параметров:
//   * Получатель - Массив - коллекция имен получателей;
//   * Тема - Строка - тема письма;
//   * Текст - Строка - текст письма;
//   * Вложения - Структура - коллекция вложений:
//    ** АдресВоВременномХранилище - Строка - адрес вложения во временном хранилище;
//    ** Представление - Строка - имя файла вложения.
//  ОбъектыПечати - Массив - коллекция объектов, по которым сформированы печатные формы.
//  ПараметрыВывода - Структура - параметр ПараметрыВывода в вызове процедуры Печать.
//  ПечатныеФормы - ТаблицаЗначений - коллекция табличных документов:
//   * Название - Строка - название печатной формы;
//   * ТабличныйДокумент - ТабличныйДокумент - печатая форма.
Процедура ПередОтправкойПоПочте(ПараметрыОтправки, ПараметрыВывода, ОбъектыПечати, ПечатныеФормы) Экспорт
	
	ОтправкаПочтовыхСообщений.ЗаполнитьТемуПолучателяПисьма(ОбъектыПечати, ПечатныеФормы, ПараметрыОтправки, , ПараметрыВывода);
	
КонецПроцедуры

#КонецОбласти
