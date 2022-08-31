
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	ОтправкаПочтовыхСообщений.ПриСозданииНаСервере(ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
	
		Объект.ВидОперации = Перечисления.СМС_ВидыОперацииДокументаДисконтирования.Выдача;
		Объект.СчетДт      = ПланыСчетов.Хозрасчетный.ДругиеФинансовыеЗатраты;
		Объект.СчетКт      = ПланыСчетов.Хозрасчетный.ПрочиеДоходыОтФинансовыхОпераций;
		Объект.ВДнях       = Истина;
		Объект.ВидОперации = Перечисления.СМС_ВидыОперацииДокументаДисконтирования.Выдача;
	КонецЕсли;
	
	ПодготовитьФормуНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	 
	ПодготовитьФормуНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ОбщегоНазначенияБПКлиент.ОбработкаОповещенияФормыДокумента(ЭтаФорма, Объект.Ссылка, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Заполнить(Команда)
	Если Объект.РасшифровкаДисконтирования.Количество() > 0 Тогда

		ДополнительныеПараметры = Новый Структура;
		
		Оповещение = Новый ОписаниеОповещения(
			"ВопросПередЗаполнениемТабличнойЧастиЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ТекстВопроса = НСтр("ru='Перед заполнением табличная часть будет очищена. Заполнить?';uk='Перед заповненням таблична частина буде очищена. Заповнити?'");
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Да);
	Иначе
		ЗаполнитьРасшифровкуДисконтирования();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВопросПередЗаполнениемТабличнойЧастиЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда		
		Объект.РасшифровкаДисконтирования.Очистить();
		ЗаполнитьРасшифровкуДисконтирования();
	Иначе
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросПередЗаполнениемИзменениемПараметров(Ответ, ДополнительныеПараметры) Экспорт
	
	ИмяПараметра = ДополнительныеПараметры.ИмяПараметра;
	
	Если Ответ = КодВозвратаДиалога.Да Тогда		
		Объект.РасшифровкаДисконтирования.Очистить();
		Если ИмяПараметра = "ВДнях" Тогда
			Если Расшифровка = 1 Тогда
				мСтруктураЗапоминающихПараметров.Вставить("ВДнях", Ложь);
				Объект.ВДнях = Ложь;
			Иначе
				мСтруктураЗапоминающихПараметров.Вставить("ВДнях", Истина);
				Объект.ВДнях = Истина;
			КонецЕсли;
			Модифицированность = Истина;
		Иначе
			мСтруктураЗапоминающихПараметров.Вставить(ИмяПараметра, Объект[ИмяПараметра]);
		КонецЕсли;
	ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда
		Если ИмяПараметра = "ВДнях" Тогда
			Если мСтруктураЗапоминающихПараметров[ИмяПараметра] = Истина Тогда
				Расшифровка = 0;
			Иначе
				Расшифровка = 1;
			КонецЕсли;
		Иначе
			Объект[ИмяПараметра] = мСтруктураЗапоминающихПараметров[ИмяПараметра];
		КонецЕсли;
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРасшифровкуДисконтирования()
	
	Перем ТаблицаЗнч;
	
	ТаблицаЗнч = Новый ТаблицаЗначений;
	ТаблицаЗнч = Объект.РасшифровкаДисконтирования.Выгрузить();
	ТаблицаЗнч.Очистить();
	
	ЗаполнитьТаблицуЗначений(ТаблицаЗнч);
	Объект.РасшифровкаДисконтирования.Загрузить(ТаблицаЗнч);
	Модифицированность = Истина;	

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуЗначений(Знач ТаблицаЗнч)
	
	Перем КвоДнейВГоду, СтавкаМес, Стр, СтрТабЗнач, Сч, текСрок;
	
	текДата = Объект.ДатаВыдачи;
	предОст3771 = 0; 
	предОст3770 = 0;
	
	Пока текДата < Объект.ДатаВозврата Цикл
		Стр = ТаблицаЗнч.Добавить();
		Стр.ДатаНачала= текДата;
		Если Объект.ВДнях Тогда
			Стр.ДатаКонца	= текДата;
		Иначе
			Стр.ДатаКонца	= мин(Объект.ДатаВозврата, КонецМесяца(Стр.ДатаНачала));
		КонецЕсли;
		Стр.КвоДней		= Стр.ДатаКонца - Стр.ДатаНачала + 1;
		КвоДнейВГоду	= ДеньГода(КонецГода(Стр.ДатаНачала));		
		Стр.Ставка		= Объект.ГодовойПроцент / КвоДнейВГоду;
		Если ТаблицаЗнч.Количество() = 1 Тогда
			Стр.ВыдачаФинПомощи	= Объект.СуммаФинПомощи;
		КонецЕсли;
		Стр.НачОстДт  = предОст3771;
		Стр.КонОстДт  = Стр.НачОстДт + Стр.ВыдачаФинПомощи - Стр.ВозвратФинПомощи; 
		предОст3771 = Стр.КонОстДт;
		текДата     = КонецДня(Стр.ДатаКонца) + 1;
	КонецЦикла;
	
	текСрок = ТаблицаЗнч.Количество();
	Если текСрок = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если Объект.ВДнях Тогда
		СтавкаМес = Стр.Ставка/100; 
	Иначе
		СтавкаМес = Окр(Объект.ГодовойПроцент / 100 / 12, 6, 1);
	КонецЕсли;
	
	Для Каждого СтрТабЗнач Из ТаблицаЗнч Цикл
		СтрТабЗнач.НачОстКт = предОст3770;
		Если СтрТабЗнач.НомерСтроки = ТаблицаЗнч.Количество() Тогда  
			СтрТабЗнач.ВозвратФинПомощи = ТаблицаЗнч.Итог("ВыдачаФинПомощи");
			СтрТабЗнач.КонОстДт = СтрТабЗнач.НачОстДт + СтрТабЗнач.ВыдачаФинПомощи - СтрТабЗнач.ВозвратФинПомощи; 
		КонецЕсли;
		СтрТабЗнач.ОстСрок = текСрок;  
		СтрТабЗнач.НачБаза = Объект.СуммаФинПомощи / Pow(1+СтавкаМес, СтрТабЗнач.ОстСрок); 
		СтрТабЗнач.ПроцентыРасход	= (СтрТабЗнач.НачОстДт + СтрТабЗнач.ВыдачаФинПомощи - СтрТабЗнач.НачОстКт) - СтрТабЗнач.НачБаза; 
		Если Макс(СтрТабЗнач.ПроцентыРасход, -СтрТабЗнач.ПроцентыРасход) < 0.10 Тогда
			//округления --> исправим НачБаза
			СтрТабЗнач.НачБаза = СтрТабЗнач.НачБаза + СтрТабЗнач.ПроцентыРасход; 
			СтрТабЗнач.ПроцентыРасход = 0;
		КонецЕсли;	
		СтрТабЗнач.ПроцентыДоход	= СтрТабЗнач.НачБаза * СтавкаМес;  
		СтрТабЗнач.КонОстКт		= СтрТабЗнач.НачОстКт + СтрТабЗнач.ПроцентыРасход - СтрТабЗнач.ПроцентыДоход;
		Если Макс(СтрТабЗнач.КонОстКт, -СтрТабЗнач.КонОстКт) < 0.10 Тогда
			//округления --> исправим ПроцентыДоход
			СтрТабЗнач.ПроцентыДоход = СтрТабЗнач.ПроцентыДоход + СтрТабЗнач.КонОстКт; 
			СтрТабЗнач.КонОстКт = 0;
		КонецЕсли;	
		предОст3770		= СтрТабЗнач.КонОстКт; 
		текСрок			= текСрок - 1;
	КонецЦикла;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ПодготовитьФормуНаСервере()

	УстановитьФункциональныеОпцииФормы();
	
	ТекущаяДатаДокумента	= Объект.Дата;
	 		
	ОбновитьИменаКолонокТабЧасти();
	
	УправлениеФормой(ЭтаФорма);
	
	УстановитьЗаголовокФормы();

КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовокФормы()
	
	ЭтаФорма.Автозаголовок = Ложь;
	
	ТекстЗаголовка	= НСтр("ru='Дисконтирование финансовой помощи';uk='Дисконтування фінансової допомоги'");
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ТекстЗаголовка = ТекстЗаголовка + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru=' %1 от %2';uk=' %1 від %2'"), Объект.Номер, Объект.Дата);
	Иначе
		ТекстЗаголовка = ТекстЗаголовка + НСтр("ru=' (создание)';uk=' (створення)'");
	КонецЕсли;
	
	ЭтаФорма.Заголовок = ТекстЗаголовка + " (" + Строка(Объект.ВидОперации) + ")";

КонецПроцедуры

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()
	ОбщегоНазначенияБПКлиентСервер.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтаФорма);
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	Объект   = Форма.Объект;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьИменаКолонокТабЧасти()
		
	НачОстДтРусский = "Нач остаток " + Объект.СчетФинПомощи + " счета";
	НачОстДтУкр     = "Поч залишок " + Объект.СчетФинПомощи + " рахунку";
	Элементы.РасшифровкаДисконтированияНачОстДт.Заголовок = НСтр("ru='" + НачОстДтРусский + "';uk='" + НачОстДтУкр + "'");
	
	НачОстКтРусский = "Нач остаток " + Объект.СчетФинПомощьДисконт + " счета";
	НачОстКтУкр     = "Поч залишок " + Объект.СчетФинПомощьДисконт + " рахунку";
	Элементы.РасшифровкаДисконтированияНачОстКт.Заголовок = НСтр("ru='" + НачОстКтРусский + "';uk='" + НачОстКтУкр + "'");
	
	КонОстДтРусский = "Кон остаток " + Объект.СчетФинПомощи + " счета";
	КонОстДтУкр     = "Кін залишок " + Объект.СчетФинПомощи + " рахунку";
	Элементы.РасшифровкаДисконтированияКонОстДт.Заголовок = НСтр("ru='" + КонОстДтРусский + "';uk='" + КонОстДтУкр + "'");
	
	КонОстКтРусский = "Кон остаток " + Объект.СчетФинПомощьДисконт + " счета";
	КонОстКтУкр     = "Кін залишок " + Объект.СчетФинПомощьДисконт + " рахунку";
	Элементы.РасшифровкаДисконтированияКонОстКт.Заголовок = НСтр("ru='" + КонОстКтРусский + "';uk='" + КонОстКтУкр + "'");

КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		ОрганизацияПриИзмененииНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	УстановитьФункциональныеОпцииФормы();
	
	ЗаполнениеДокументов.ПриИзмененииЗначенияОрганизации(Объект, Пользователи.ТекущийПользователь());
	
	Если ЗначениеЗаполнено(Объект.Контрагент) Тогда
		КонтрагентПриИзмененииНаСервере();
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура КонтрагентПриИзмененииНаСервере()

	КонтрагентОбработатьИзменениеНаСервере();
	
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаСервере
Процедура КонтрагентОбработатьИзменениеНаСервере()

	БухгалтерскийУчетПереопределяемый.УстановитьДоговорКонтрагента(
		Объект.ДоговорКонтрагента, Объект.Контрагент, Объект.Организация);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.Контрагент) Тогда
		КонтрагентПриИзмененииНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СчетФинПомощиПриИзменении(Элемент)
	ОбновитьИменаКолонокТабЧасти();
КонецПроцедуры

&НаКлиенте
Процедура СчетФинПомощьДисконтПриИзменении(Элемент)
	ОбновитьИменаКолонокТабЧасти();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	мСтруктураЗапоминающихПараметров = Новый Структура;
	мСтруктураЗапоминающихПараметров.Вставить("ГодовойПроцент", Объект.ГодовойПроцент);
	мСтруктураЗапоминающихПараметров.Вставить("ВДнях", Объект.ВДнях);
	мСтруктураЗапоминающихПараметров.Вставить("СуммаФинПомощи", Объект.СуммаФинПомощи);
	мСтруктураЗапоминающихПараметров.Вставить("ДатаВыдачи", Объект.ДатаВыдачи);
	мСтруктураЗапоминающихПараметров.Вставить("ДатаВозврата", Объект.ДатаВозврата);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидОперацииПриИзменении(Элемент)
	УстановитьЗаголовокФормы();
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	УстановитьЗаголовокФормы();
	УстановитьСостояниеДокумента();
КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	СостояниеДокумента = ОбщегоНазначенияБП.СостояниеДокумента(Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПриИзменении(Элемент)
	ПриИзмененииПараметров("ВДнях");
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииПараметров(ИмяПараметра)
	
	Если Объект.РасшифровкаДисконтирования.Количество() > 0 Тогда

		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ИмяПараметра", ИмяПараметра);
		
		Оповещение = Новый ОписаниеОповещения(
			"ВопросПередЗаполнениемИзменениемПараметров", ЭтотОбъект, ДополнительныеПараметры);
		ТекстВопроса = НСтр("ru='Перед заполнением табличная часть будет очищена. Заполнить?';uk='Перед заповненням таблична частина буде очищена. Заповнити?'");
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Да);
	Иначе
		Если ИмяПараметра = "ВДнях" Тогда
			Если Расшифровка = 1 Тогда
				мСтруктураЗапоминающихПараметров.Вставить("ВДнях", Ложь);
				Объект.ВДнях = Ложь;
			Иначе
				мСтруктураЗапоминающихПараметров.Вставить("ВДнях", Истина);
				Объект.ВДнях = Истина;
			КонецЕсли;
			Модифицированность = Истина;
		Иначе
			мСтруктураЗапоминающихПараметров.Вставить(ИмяПараметра, ЭтотОбъект[ИмяПараметра]);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаВыдачиПриИзменении(Элемент)
	ПриИзмененииПараметров("ДатаВыдачи");
КонецПроцедуры

&НаКлиенте
Процедура ДатаВозвратаПриИзменении(Элемент)
	ПриИзмененииПараметров("ДатаВозврата");
КонецПроцедуры

&НаКлиенте
Процедура ГодовойПроцентПриИзменении(Элемент)
	ПриИзмененииПараметров("ГодовойПроцент");
КонецПроцедуры

&НаКлиенте
Процедура СуммаФинПомощиПриИзменении(Элемент)
	ПриИзмененииПараметров("СуммаФинПомощи");
КонецПроцедуры

#Область СлужебныеПроцедурыИФункцииБСП

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти    //СлужебныеПроцедурыИФункцииБСП
