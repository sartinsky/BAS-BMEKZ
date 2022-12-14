#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПроцедурыИФункцииПечати

Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Реестр";
	КомандаПечати.Представление = НСтр("ru='Реестр документов';uk='Реєстр документів'");
	КомандаПечати.ЗаголовокФормы= НСтр("ru='Реестр документов ""Реализация коммунальных услуг""';uk='Реєстр документів ""Реализация коммунальных услуг""'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм    = "ФормаСписка";
	КомандаПечати.Порядок       = 100;

КонецПроцедуры

Функция ПолучитьДополнительныеРеквизитыДляРеестра() Экспорт
	
	Результат = Новый Структура;
		
	Возврат Результат;
	
КонецФункции

#КонецОбласти 

#Область ПрограммныйИнтерфейс

// Заполняет счета учета расчетов
//
// Параметры:
// Объект - СправочникСсылка - объект контактной информации
// СчетаУчета - Булево - указывать счет учета или нет.
//
Процедура ЗаполнитьСчетаУчетаРасчетов(Объект, СчетаУчета = Неопределено) Экспорт
	
	Если СчетаУчета = Неопределено Тогда
		СчетаУчета = БухгалтерскийУчетПереопределяемый.ПолучитьСчетаРасчетовСКонтрагентом(
			Объект.Организация, Объект.Контрагент, Объект.ДоговорКонтрагента);
	КонецЕсли;
	
	ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	ПлательщикНДС = УчетнаяПолитика.ПлательщикНДС(Объект.Организация, Объект.Дата);
	
	РеквизитыДоговора = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.ДоговорКонтрагента, "ВидДоговора, ВалютаВзаиморасчетов, СложныйНалоговыйУчет");
	
	ЭтоКомиссия          = РеквизитыДоговора.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.СКомиссионером;
	ЭтоБартер            = РеквизитыДоговора.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.Бартерный;
	Внешнеэкономический  = ЗначениеЗаполнено(Объект.ДоговорКонтрагента) И (РеквизитыДоговора.ВалютаВзаиморасчетов <> ВалютаРегламентированногоУчета);
	СложныйНалоговыйУчет = ЗначениеЗаполнено(Объект.ДоговорКонтрагента) И (РеквизитыДоговора.СложныйНалоговыйУчет);

	Если ЭтоКомиссия Тогда
		Объект.СчетУчетаРасчетовСКонтрагентом   = ПланыСчетов.Хозрасчетный.ПустаяСсылка();
		Объект.СчетУчетаРасчетовПоАвансам       = ПланыСчетов.Хозрасчетный.ПустаяСсылка();
	ИначеЕсли ЭтоБартер Тогда
		Объект.СчетУчетаРасчетовСКонтрагентом   = СчетаУчета.СчетРасчетовПокупателяПриБартере;
		Объект.СчетУчетаРасчетовПоАвансам       = СчетаУчета.СчетАвансовПокупателяПриБартере;
	Иначе
		Объект.СчетУчетаРасчетовСКонтрагентом   = СчетаУчета.СчетРасчетовПокупателя;
		Объект.СчетУчетаРасчетовПоАвансам 	    = СчетаУчета.СчетАвансовПокупателя;
	КонецЕсли;  	
		
	Если Не РеализацияТоваровУслугФормыКлиентСервер.ИспользуетсяСчетУчетаНДС(ПлательщикНДС, ЭтоКомиссия, Объект.Дата) Тогда		
		Объект.СчетУчетаНДС 					= ПланыСчетов.Хозрасчетный.ПустаяСсылка();
	Иначе
		Объект.СчетУчетаНДС 					= СчетаУчета.СчетУчетаНДСПродаж;		
	КонецЕсли;
	
	Если Не РеализацияТоваровУслугФормыКлиентСервер.ИспользуетсяСчетУчетаНДСПодтвержденный(ПлательщикНДС, ЭтоКомиссия, Объект.Дата, СложныйНалоговыйУчет) Тогда
		Объект.СчетУчетаНДСПодтвержденный       = ПланыСчетов.Хозрасчетный.ПустаяСсылка();
	Иначе
		Объект.СчетУчетаНДСПодтвержденный       = СчетаУчета.СчетУчетаНДСПродажПодтвержденный;		
	КонецЕсли;
	
КонецПроцедуры

// Заполняет счета учета номенклатуры в табличной части документа
//
// Параметры:
// Объект - СправочникСсылка - объект контактной информации
// ИмяТабличнойЧасти - имя табличной части.
//
Процедура ЗаполнитьСчетаУчетаВТабличнойЧасти(Объект, ИмяТабличнойЧасти) Экспорт

	ТабличнаяЧасть = Объект[ИмяТабличнойЧасти];
	
	ДанныеОбъекта = Новый Структура("Дата, Организация");
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);
	
	СоответствиеСведенийОНоменклатуре = БухгалтерскийУчетПереопределяемый.ПолучитьСведенияОСпискеНоменклатуры(
		ОбщегоНазначения.ВыгрузитьКолонку(ТабличнаяЧасть, "Номенклатура", Истина), ДанныеОбъекта); 		
		
	Для каждого СтрокаТабличнойЧасти Из ТабличнаяЧасть Цикл
		СведенияОНоменклатуре = СоответствиеСведенийОНоменклатуре.Получить(СтрокаТабличнойЧасти.Номенклатура);
		ЗаполнитьСчетаУчетаВСтрокеТабличнойЧасти(ДанныеОбъекта, СтрокаТабличнойЧасти, ИмяТабличнойЧасти, СведенияОНоменклатуре);
	КонецЦикла;

КонецПроцедуры

// Заполняет счета учета номенклатуры в строке табличной части документа
//
// Параметры:
//  ДанныеОбъекта         - структура данных объекта, используемых при заполнении счетов учета (вид операции,
//                          вид договора контрагента, признак комиссионной торговли и т.п.)
//  СтрокаТабличнойЧасти  - строка табличной части документа
//  ИмяТабличнойЧасти     - имя табличной части документа
//  СведенияОНоменклатуре - структура сведений о номенклатуре, либо структура счетов учета
//
Процедура ЗаполнитьСчетаУчетаВСтрокеТабличнойЧасти(ДанныеОбъекта, СтрокаТабличнойЧасти, ИмяТабличнойЧасти, СведенияОНоменклатуре) Экспорт

	Если СведенияОНоменклатуре = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если СведенияОНоменклатуре.Свойство("СчетаУчета") Тогда
		// СведенияОНоменклатуре - структура сведений номенклатуры
		СчетаУчета = СведенияОНоменклатуре.СчетаУчета;
	ИначеЕсли СведенияОНоменклатуре.Свойство("СчетУчетаБУ") Тогда
		// СведенияОНоменклатуре - структура счетов учета номенклатуры
		СчетаУчета = СведенияОНоменклатуре;
	Иначе
		Возврат;
	КонецЕсли; 	
		
	Если ЗначениеЗаполнено(СчетаУчета.СхемаРеализации) Тогда
		СтрокаТабличнойЧасти.СхемаРеализации = СчетаУчета.СхемаРеализации;
	КонецЕсли;       		
		
	Если ЗначениеЗаполнено(СчетаУчета.НалоговоеНазначение) Тогда
		СтрокаТабличнойЧасти.НалоговоеНазначение = СчетаУчета.НалоговоеНазначение;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СчетаУчета.НалоговоеНазначениеДоходовИЗатрат) Тогда
		СтрокаТабличнойЧасти.НалоговоеНазначениеДоходовИЗатрат = СчетаУчета.НалоговоеНазначениеДоходовИЗатрат;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти 

#КонецЕсли