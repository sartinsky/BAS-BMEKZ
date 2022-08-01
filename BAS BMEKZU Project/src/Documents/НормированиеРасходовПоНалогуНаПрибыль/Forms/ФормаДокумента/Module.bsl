#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	
	ЗаполнитьИнформациюОНормируемыхСтатьях();
	ЗаполнитьСлужебныеРеквизитыТЧСтатьи();
	
	ПодготовитьФормуНаСервере();
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ЗаполнитьИнформациюОНормируемыхСтатьях();
	ЗаполнитьСлужебныеРеквизитыТЧСтатьи();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ЗаполнитьСлужебныеРеквизитыТЧСтатьи();
	
	УстановитьСостояниеДокумента();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)

	Если НачалоДня(Объект.Дата) = НачалоДня(ТекущаяДатаДокумента) Тогда
		// Изменение времени не влияет на поведение документа.
		ТекущаяДатаДокумента = Объект.Дата;
		Возврат;
	КонецЕсли;

	// Общие проверки условий по датам.
	ТребуетсяВызовСервера = ОбщегоНазначенияБПКлиент.ТребуетсяВызовСервераПриИзмененииДатыДокумента(Объект.Дата, 
		ТекущаяДатаДокумента);
		
	// Если определили, что изменение даты может повлиять на какие-либо параметры, 
	// то передаем обработку на сервер.
	Если ТребуетсяВызовСервера Тогда
		ДатаПриИзмененииНаСервере();
	КонецЕсли;
	
	// Запомним новую дату документа.
	ТекущаяДатаДокумента = Объект.Дата;

КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)

	ОрганизацияПриИзмененииСервер();

КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования,
		ЭтотОбъект,
		"Объект.Комментарий"
	);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыСтатьи

&НаКлиенте
Процедура СтатьиСтатьяПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Статьи.ТекущиеДанные;
	
	ДанныеСтроки = Новый Структура("Статья, Пояснение");
	ЗаполнитьЗначенияСвойств(ДанныеСтроки, ТекущиеДанные);
	
	ЗаполнитьПояснениеПоСтатье(ДанныеСтроки);
	
	ЗаполнитьЗначенияСвойств(ТекущиеДанные, ДанныеСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьиСуммаОборотПриИзменении(Элемент)
	
	СтрокаТаблицы = Элементы.Статьи.ТекущиеДанные;
	РассчитатьСуммуПревышения(СтрокаТаблицы);
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьиСуммаВПределелахНормПриИзменении(Элемент)
	
	СтрокаТаблицы = Элементы.Статьи.ТекущиеДанные;
	РассчитатьСуммуПревышения(СтрокаТаблицы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьПоДаннымУчета(Команда)
	
	
    Если Параметры.Ключ.Пустая() Тогда  // новый документ
        
        ТекстВопроса = НСтр("ru='Документ перед заполнением должен быть записан. Продолжить?';uk='Документ перед заповненням має бути записаний. Продовжити?'");
        ПоказатьВопрос(Новый ОписаниеОповещения("ЗаполнитьПоДаннымУчетаЗаписьДокумента", ЭтотОбъект), ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
        Возврат;
        
    КонецЕсли;
	ЗаполнитьПоДаннымУчетаШаг2();
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьВыручкуПрошлогоГода(Команда)
	РассчитатьВыручкуПрошлогоГодаНаСервере();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовитьФормуНаСервере()

	ТекущаяДатаДокумента 			= Объект.Дата;
	
	УстановитьСостояниеДокумента();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	СостояниеДокумента = ОбщегоНазначенияБП.СостояниеДокумента(Объект);
	
КонецПроцедуры

&НаСервере
Процедура ДатаПриИзмененииНаСервере()

	ОбщегоНазначенияБПКлиентСервер.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтаФорма);

КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииСервер()

	ОбщегоНазначенияБПКлиентСервер.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтаФорма);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСлужебныеРеквизитыТЧСтатьи()

	Для каждого СтрокаТаблицы Из Объект.Статьи Цикл
		
		ЗаполнитьПояснениеПоСтатье(СтрокаТаблицы);
		РассчитатьСуммуПревышения(СтрокаТаблицы);
	
	КонецЦикла; 

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьИнформациюОНормируемыхСтатьях()
	

	СписокНормируемыхСтатей.Очистить();
	СписокНормируемыхСтатей.Добавить(Справочники.СтатьиНалоговыхДеклараций.НПНК_ВЗ_Реклама_Нерезиденты,	"Витрати, понесені (нараховані) у зв'язку із придбанням у нерезидента послуг (робіт) з маркетингу, реклами в обсязі, що не перевищує 4 % доходу (виручки) від реалізації продукції (товарів, робіт, послуг) за рік, що передує звітному");
	СписокНормируемыхСтатей.Добавить(Справочники.СтатьиНалоговыхДеклараций.НПНК_ИВ_БезоплатноБюджет,		"Суми коштів або вартість товарів, виконаних робіт, наданих послуг, добровільно перераховані (передані) протягом звітного року до Державного бюджету України або бюджетів місцевого самоврядування, до неприбуткових організацій у розмірі, що не перевищує 4 % оподатковуваного прибутку попереднього звітного року");
	СписокНормируемыхСтатей.Добавить(Справочники.СтатьиНалоговыхДеклараций.НПНК_ИВ_БезоплатноПрофсоюзы,	"Суми коштів, перераховані роботодавцями первинним профспілковим організаціям на культурно-масову, фізкультурну та оздоровчу роботу, передбачені колективними договорами (угодами) відповідно до Закону України ""Про професійні спілки, їх права та гарантії діяльності"", в межах 4 % оподатковуваного прибутку за попередній звітний рік з урахуванням положень абзацу ""а"" підпункту 138.10.6 пункту 138.10 статті 138 розділу III Податкового кодексу України");
	СписокНормируемыхСтатей.Добавить(Справочники.СтатьиНалоговыхДеклараций.НПНК_ИВ_БезоплатноЧернобыльские,"Суми коштів, перераховані підприємствами всеукраїнських об'єднань осіб, які постраждали внаслідок Чорнобильської катастрофи, на яких працює за основним місцем роботи не менш як 75 % таких осіб цим об'єднанням для ведення благодійної діяльності, але не більше 10 % оподатковуваного прибутку попереднього звітного року");
	СписокНормируемыхСтатей.Добавить(Справочники.СтатьиНалоговыхДеклараций.НПНК_ИВ_БезоплатноКультура, 	"Суми коштів або вартість майна, добровільно перераховані/передані для цільового використання з метою охорони культурної спадщини установам науки, освіти, культури, заповідникам, музеям, музеям-заповідникам у розмірі, що не перевищує 10 % оподатковуваного прибутку за попередній звітний рік");
	СписокНормируемыхСтатей.Добавить(Справочники.СтатьиНалоговыхДеклараций.НПНК_ИВ_БезоплатноКинематограф, "Суми коштів або вартість майна, добровільно перераховані/передані на користь резидентів для цільового використання з метою виробництва національних фільмів (у тому числі анімаційних) та аудіовізуальних творів, але не більше 10 % оподатковуваного прибутку за попередній податковий рік");
	СписокНормируемыхСтатей.Добавить(Справочники.СтатьиНалоговыхДеклараций.НПНК_ИВ_Роялти_Нерезиденты, 	"Роялті, нараховані на користь нерезидента в обсязі, що не перевищує 4 % доходу (виручки) від реалізації продукції (товарів, робіт, послуг) за рік, що передує звітному");
	СписокНормируемыхСтатей.Добавить(Справочники.СтатьиНалоговыхДеклараций.НПНК_ПЗ_Роялти_Нерезиденты, 	"Роялті, нараховані на користь нерезидента в обсязі, що не перевищує 4 % доходу (виручки) від реалізації продукції (товарів, робіт, послуг) за рік, що передує звітному");
	СписокНормируемыхСтатей.Добавить(Справочники.СтатьиНалоговыхДеклараций.НПНК_ИВ_Консалтинг_Нерезиденты, "Витрати, понесенні (нараховані) у зв'язку із придбанням у нерезидента послуг (робіт) з консалтингу в обсязі, що не перевищує 4 % доходу (виручки) від реалізації продукції (товарів, робіт, послуг) за рік, що передує звітному");
	СписокНормируемыхСтатей.Добавить(Справочники.СтатьиНалоговыхДеклараций.НПНК_ПЗ_Консалтинг_Нерезиденты, "Витрати, понесенні (нараховані) у зв'язку із придбанням у нерезидента послуг (робіт) з консалтингу в обсязі, що не перевищує 4 % доходу (виручки) від реалізації продукції (товарів, робіт, послуг) за рік, що передує звітному");
	СписокНормируемыхСтатей.Добавить(Справочники.СтатьиНалоговыхДеклараций.НПНК_ИВ_Инжиниринг_Нерезиденты, "Витрати, понесенні (нараховані) у зв'язку із придбанням у нерезидента послуг (робіт) з інжинірингу в обсязі, що не перевищує 5 % митної вартості обладнання, імпортованого згідно з відповідним контрактом");
	СписокНормируемыхСтатей.Добавить(Справочники.СтатьиНалоговыхДеклараций.НПНК_ПЗ_Инжиниринг_Нерезиденты, "Витрати, понесенні (нараховані) у зв'язку із придбанням у нерезидента послуг (робіт) з інжинірингу в обсязі, що не перевищує 5 % митної вартості обладнання, імпортованого згідно з відповідним контрактом");

	СписокНередактируемыхСтатей.Очистить();
	СписокНередактируемыхСтатей.Добавить(Справочники.СтатьиНалоговыхДеклараций.НПНК_ПЗ_Роялти_Нерезиденты);
	СписокНередактируемыхСтатей.Добавить(Справочники.СтатьиНалоговыхДеклараций.НПНК_ПЗ_Консалтинг_Нерезиденты);
	СписокНередактируемыхСтатей.Добавить(Справочники.СтатьиНалоговыхДеклараций.НПНК_ПЗ_Инжиниринг_Нерезиденты);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура РассчитатьСуммуПревышения(СтрокаТаблицы)
	
	СтрокаТаблицы.СуммаПревышения = СтрокаТаблицы.СуммаОборот - СтрокаТаблицы.СуммаВПределелахНорм;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПояснениеПоСтатье(СтрокаТаблицы)
	
	СтрокаТаблицы.Пояснение = "";
	Если ЗначениеЗаполнено(СтрокаТаблицы.Статья)  Тогда
		НормируемаяСтатья = СписокНормируемыхСтатей.НайтиПоЗначению(СтрокаТаблицы.Статья);
		Если НЕ НормируемаяСтатья = Неопределено Тогда
			СтрокаТаблицы.Пояснение = НормируемаяСтатья.Представление;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоДаннымУчетаЗаписьДокумента(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
	Если РезультатВопроса =  КодВозвратаДиалога.Да Тогда
		
	    Записать();
	    ЗаполнитьПоДаннымУчетаШаг2();
		
    КонецЕсли; 

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоДаннымУчетаШаг2()
    
	Если Объект.Статьи.Количество() > 0 Тогда

		ТекстВопроса = НСтр("ru='Перед заполнением табличная часть будет очищена. Заполнить?';uk='Перед заповненням таблична частина буде очищена. Заповнити?'");
		Ответ = Неопределено;

		ПоказатьВопрос(Новый ОписаниеОповещения("ЗаполнитьПоДаннымУчетаОчисткаТЧСтатьи", ЭтотОбъект), ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
        Возврат;
		
	КонецЕсли;
    
    ЗаполнитьПоДаннымУчетаНаконецтоЗаполнить();

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоДаннымУчетаОчисткаТЧСтатьи(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
    
	    Объект.Статьи.Очистить();
		ЗаполнитьПоДаннымУчетаНаконецтоЗаполнить();
		
    КонецЕсли; 

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоДаннымУчетаНаконецтоЗаполнить()
    
    ЗаполнитьПоДаннымУчетаНаСервере();

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоДаннымУчетаНаСервере()
	
	ТабЧасть = Объект.Статьи;
	
	МассивНормируемыхСтатей = Новый Массив;
	Для каждого НормСтатья Из СписокНормируемыхСтатей Цикл
		МассивНормируемыхСтатей.Добавить(НормСтатья.Значение)
	КонецЦикла;
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Запрос.УстановитьПараметр("ДатаНач", НачалоГода(Объект.Дата));
	Запрос.УстановитьПараметр("ДатаКон", Объект.Ссылка.МоментВремени());
	
	Запрос.УстановитьПараметр("НормируемыеСтатьи", МассивНормируемыхСтатей);
	
	СчетаЗатрат = Новый Массив();
	ИспользуемыеКлассыСчетовРасходов = УчетнаяПолитика.ИспользуемыеКлассыСчетовРасходов(Объект.Организация, Объект.Дата);
	
	Если НЕ ИспользуемыеКлассыСчетовРасходов = Перечисления.КлассыСчетовРасходов.Класс8 Тогда
		СчетаЗатрат.Добавить(ПланыСчетов.Хозрасчетный.ОбщепроизводственныеРасходы);
		СчетаЗатрат.Добавить(ПланыСчетов.Хозрасчетный.АдминистративныеРасходы);
		СчетаЗатрат.Добавить(ПланыСчетов.Хозрасчетный.РасходыНаСбыт);
		СчетаЗатрат.Добавить(ПланыСчетов.Хозрасчетный.ДругиеЗатратыОперационнойДеятельностиГруппа);
	Иначе
		СчетаЗатрат.Добавить(ПланыСчетов.Хозрасчетный.МатериальныеЗатраты);
		СчетаЗатрат.Добавить(ПланыСчетов.Хозрасчетный.ЗатратыНаОплатуТруда);
		СчетаЗатрат.Добавить(ПланыСчетов.Хозрасчетный.ОтчисленияНаСоциальныеМероприятия);
		СчетаЗатрат.Добавить(ПланыСчетов.Хозрасчетный.Амортизация);
		СчетаЗатрат.Добавить(ПланыСчетов.Хозрасчетный.ДругиеОперационныеЗатраты);
		СчетаЗатрат.Добавить(ПланыСчетов.Хозрасчетный.ДругиеЗатратыПоЭлементам);
	КонецЕсли;		
	СчетаЗатрат.Добавить(ПланыСчетов.Хозрасчетный.ОсновноеПроизводство);
	СчетаЗатрат.Добавить(ПланыСчетов.Хозрасчетный.ВспомогательныеПроизводства);
	
	Запрос.УстановитьПараметр("СчетаЗатрат", СчетаЗатрат);
	
	Запрос.УстановитьПараметр("СтатьиЗатрат", ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.СтатьиЗатрат);
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ХозрасчетныйОбороты.Субконто1.СтатьяДекларацииПоНалогуНаПрибыль КАК Статья,
	               |	ХозрасчетныйОбороты.СуммаНУОборотДт КАК СуммаОборот,
	               |	ХозрасчетныйОбороты.НалоговоеНазначение КАК НалоговоеНазначениеДоходовИЗатрат
	               |ИЗ
	               |	РегистрБухгалтерии.Хозрасчетный.Обороты(&ДатаНач, &ДатаКон, Период, Счет В ИЕРАРХИИ (&СчетаЗатрат), &СтатьиЗатрат, Организация = &Организация И Субконто1.СтатьяДекларацииПоНалогуНаПрибыль В (&НормируемыеСтатьи)) КАК ХозрасчетныйОбороты";
	
	ТаблицаЗатрат = Запрос.Выполнить().Выгрузить();
	
	ПараметрНУСрез = РегистрыСведений.ПараметрыНалоговогоУчета.СрезПоследних(Объект.Дата);
	
	СуммаВПределелахНорм_БезоплатноБюджетПрофсоюзы = 0;
	СуммаВПределелахНорм_Роялти = 0;
	СуммаВПределелахНорм_Консалтинг = 0;
	СуммаВПределелахНорм_Инжиниринг = 0;
	
	Для каждого ТекСтатья Из МассивНормируемыхСтатей Цикл
		
		СуммаОграниченияПоНорме = ПолучитьСуммуОграниченияПоСтатье(ПараметрНУСрез, ТекСтатья);
		
		Если    ТекСтатья = Справочники.СтатьиНалоговыхДеклараций.НПНК_ИВ_БезоплатноПрофсоюзы
			ИЛИ ТекСтатья = Справочники.СтатьиНалоговыхДеклараций.НПНК_ИВ_БезоплатноБюджет Тогда
		
			РассчитатьПоСтатье(ТекСтатья, ТаблицаЗатрат, СуммаОграниченияПоНорме, СуммаВПределелахНорм_БезоплатноБюджетПрофсоюзы);
			
		ИначеЕсли  ТекСтатья = Справочники.СтатьиНалоговыхДеклараций.НПНК_ИВ_Роялти_Нерезиденты
			   ИЛИ ТекСтатья = Справочники.СтатьиНалоговыхДеклараций.НПНК_ПЗ_Роялти_Нерезиденты Тогда
			
			РассчитатьПоСтатье(ТекСтатья, ТаблицаЗатрат, СуммаОграниченияПоНорме, СуммаВПределелахНорм_Роялти);
			
		ИначеЕсли  ТекСтатья = Справочники.СтатьиНалоговыхДеклараций.НПНК_ИВ_Консалтинг_Нерезиденты 
			   ИЛИ ТекСтатья = Справочники.СтатьиНалоговыхДеклараций.НПНК_ПЗ_Консалтинг_Нерезиденты Тогда
			
			РассчитатьПоСтатье(ТекСтатья, ТаблицаЗатрат, СуммаОграниченияПоНорме, СуммаВПределелахНорм_Консалтинг);
			
		ИначеЕсли  ТекСтатья = Справочники.СтатьиНалоговыхДеклараций.НПНК_ИВ_Инжиниринг_Нерезиденты
			   ИЛИ ТекСтатья = Справочники.СтатьиНалоговыхДеклараций.НПНК_ПЗ_Инжиниринг_Нерезиденты Тогда
			   
			РассчитатьПоСтатье(ТекСтатья, ТаблицаЗатрат, СуммаОграниченияПоНорме, СуммаВПределелахНорм_Инжиниринг);
			
		Иначе
			
			РассчитатьПоСтатье(ТекСтатья, ТаблицаЗатрат, СуммаОграниченияПоНорме);
			
		КонецЕсли;
	
	КонецЦикла;
	
	ЗаполнитьСлужебныеРеквизитыТЧСтатьи();
	
КонецПроцедуры

&НаСервере
Функция ПолучитьСуммуОграниченияПоСтатье(Параметры, ТекСтатья)

	Если Параметры.Количество() = 0 Тогда
		Возврат 0;
	КонецЕсли;

	Если ТекСтатья = Справочники.СтатьиНалоговыхДеклараций.НПНК_ВЗ_Реклама_Нерезиденты Тогда
		
		Возврат Параметры[0].НормаРекламаНерезиденты /100 * Объект.ВыручкаПрошлогоГода;
		
	ИначеЕсли ТекСтатья = Справочники.СтатьиНалоговыхДеклараций.НПНК_ИВ_БезоплатноБюджет Тогда
	
		Возврат Параметры[0].НормаБюджетНеприбыльные /100 * Объект.ОблагаемаяПрибыльПрошлогоГода; 
		
	ИначеЕсли ТекСтатья = Справочники.СтатьиНалоговыхДеклараций.НПНК_ИВ_БезоплатноПрофсоюзы Тогда
		
		Возврат Параметры[0].НормаПрофсоюзы /100 * Объект.ОблагаемаяПрибыльПрошлогоГода; 
	
	ИначеЕсли ТекСтатья = Справочники.СтатьиНалоговыхДеклараций.НПНК_ИВ_БезоплатноЧернобыльские Тогда
		
		Возврат Параметры[0].НормаЧернобыльцы /100 * Объект.ОблагаемаяПрибыльПрошлогоГода; 
		
	ИначеЕсли ТекСтатья = Справочники.СтатьиНалоговыхДеклараций.НПНК_ИВ_БезоплатноКультура Тогда
		
		Возврат Параметры[0].НормаКультура /100 * Объект.ОблагаемаяПрибыльПрошлогоГода; 		
	
	ИначеЕсли ТекСтатья = Справочники.СтатьиНалоговыхДеклараций.НПНК_ИВ_БезоплатноКинематограф Тогда
		
		Возврат Параметры[0].НормаКинематограф /100 * Объект.ОблагаемаяПрибыльПрошлогоГода; 
			
	ИначеЕсли  ТекСтатья = Справочники.СтатьиНалоговыхДеклараций.НПНК_ИВ_Роялти_Нерезиденты
		   ИЛИ ТекСтатья = Справочники.СтатьиНалоговыхДеклараций.НПНК_ПЗ_Роялти_Нерезиденты Тогда
		
		Возврат Параметры[0].НормаРоялти /100 * Объект.ВыручкаПрошлогоГода;
		
	ИначеЕсли  ТекСтатья = Справочники.СтатьиНалоговыхДеклараций.НПНК_ПЗ_Консалтинг_Нерезиденты
		   ИЛИ ТекСтатья = Справочники.СтатьиНалоговыхДеклараций.НПНК_ИВ_Консалтинг_Нерезиденты Тогда
		
		Возврат Параметры[0].НормаКонсалтинг /100 * Объект.ВыручкаПрошлогоГода; 
		
	ИначеЕсли  ТекСтатья = Справочники.СтатьиНалоговыхДеклараций.НПНК_ИВ_Инжиниринг_Нерезиденты
		   ИЛИ ТекСтатья = Справочники.СтатьиНалоговыхДеклараций.НПНК_ПЗ_Инжиниринг_Нерезиденты Тогда
		   
		Возврат 999999999999;
		
	КонецЕсли;

КонецФункции //

&НаСервере
Процедура РассчитатьПоСтатье(ТекСтатья, ТаблицаЗатрат, Норма= 0 , Учтено = 0)

	ДанныеПоЗатратам = ТаблицаЗатрат.НайтиСтроки(Новый Структура("Статья",ТекСтатья));
	
	Если ДанныеПоЗатратам.Количество() = 0 Тогда
		НоваяСтрока = Объект.Статьи.Добавить();
		НоваяСтрока.Статья = ТекСтатья;
		НоваяСтрока.НалоговоеНазначениеДоходовИЗатрат = Справочники.НалоговыеНазначенияАктивовИЗатрат.НКУ_ХозДеятельность;
		Возврат;
	КонецЕсли;	
	
	// учитываем нормы для всех видов деятельности по каким зарегистрированым затратам
	Для каждого ДанныеПоЗатрате Из ДанныеПоЗатратам Цикл
	
		НоваяСтрока 				= Объект.Статьи.Добавить();
		НоваяСтрока.Статья 			= ТекСтатья;
		НоваяСтрока.НалоговоеНазначениеДоходовИЗатрат = ДанныеПоЗатрате.НалоговоеНазначениеДоходовИЗатрат;

		НоваяСтрока.СуммаОборот = ДанныеПоЗатрате.СуммаОборот;
		
		Если НЕ СписокНередактируемыхСтатей.НайтиПоЗначению(ТекСтатья) = Неопределено Тогда
			// суммы отнесенные в производство по нормируемым статьям должны быть отнормированы вручную
			// при их поступлении. Иначе себестоимость продукции будет завышенной
			
			НоваяСтрока.СуммаВПределелахНорм = НоваяСтрока.СуммаОборот;
			
		Иначе	
			
			Если ДанныеПоЗатрате.СуммаОборот >= Норма - Учтено  Тогда
				НоваяСтрока.СуммаВПределелахНорм = МАКС(0, Норма - Учтено);
			Иначе
				НоваяСтрока.СуммаВПределелахНорм = НоваяСтрока.СуммаОборот;
			КонецЕсли;
		
		КонецЕсли;
		
		Учтено = Учтено + НоваяСтрока.СуммаВПределелахНорм;
		   
		Если ТекСтатья = Справочники.СтатьиНалоговыхДеклараций.НПНК_ИВ_Инжиниринг_Нерезиденты
		 //ИЛИ ТекСтатья = Справочники.СтатьиНалоговыхДеклараций.НПНК_ПЗ_Инжиниринг_Нерезиденты 
		Тогда
		
			Сообщить(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Затраты в пределех нормы затрат по статье ""%1"" необходимо указать вручную!';uk='Витрати в межах норм витрат по статті ""%1"" необхідно вказати вручну!'"), ТекСтатья));
		
		КонецЕсли;   
		
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура РассчитатьВыручкуПрошлогоГодаНаСервере()
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Запрос.УстановитьПараметр("ДатаНач", НачалоГода(ДобавитьМесяц(Объект.Дата,-12)));
	Запрос.УстановитьПараметр("ДатаКон", КонецГода(ДобавитьМесяц(Объект.Дата,-12)));
	
	СчетаДоходов = Новый Массив();
	СчетаДоходов.Добавить(ПланыСчетов.Хозрасчетный.ДоходОтРеализацииГотовойПродукции);
	СчетаДоходов.Добавить(ПланыСчетов.Хозрасчетный.ДоходОтРеализацииТоваров);
	СчетаДоходов.Добавить(ПланыСчетов.Хозрасчетный.ДоходОтРеализацииРаботИУслуг);
	СчетаДоходов.Добавить(ПланыСчетов.Хозрасчетный.ДоходОтРеализацииНеоборотныхАктивов);
	Запрос.УстановитьПараметр("СчетаДоходов", СчетаДоходов);
	
	
	СчетаВычетаИзДоходов = Новый Массив();
	СчетаВычетаИзДоходов.Добавить(ПланыСчетов.Хозрасчетный.ВычетыИзДохода);
	Запрос.УстановитьПараметр("СчетаВычетаИзДоходов", СчетаВычетаИзДоходов);
	
	СчетаНалогов = Новый Массив();
	СчетаНалогов.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоНДС);
	СчетаНалогов.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоАкцизу);
	СчетаНалогов.Добавить(ПланыСчетов.Хозрасчетный.НалоговыеОбязательстваВсего);
	Запрос.УстановитьПараметр("СчетаНалогов", СчетаНалогов);
	
	Запрос.Текст ="ВЫБРАТЬ
	              |	ХозрасчетныйОбороты.СуммаОборотКт КАК ВыручкаПрошлогоГода
	              |ИЗ
	              |	РегистрБухгалтерии.Хозрасчетный.Обороты(&ДатаНач, &ДатаКон, Период, Счет В ИЕРАРХИИ (&СчетаДоходов), , Организация = &Организация, , ) КАК ХозрасчетныйОбороты
	              |
	              |СГРУППИРОВАТЬ ПО
	              |	ХозрасчетныйОбороты.СуммаОборотКт
	              |
	              |ОБЪЕДИНИТЬ ВСЕ
	              |
	              |ВЫБРАТЬ
	              |	-ХозрасчетныйОбороты.СуммаОборотДт
	              |ИЗ
	              |	РегистрБухгалтерии.Хозрасчетный.Обороты(&ДатаНач, &ДатаКон, Период, Счет В ИЕРАРХИИ (&СчетаДоходов), , Организация = &Организация, КорСчет В ИЕРАРХИИ (&СчетаНалогов), ) КАК ХозрасчетныйОбороты
	              |
	              |ОБЪЕДИНИТЬ ВСЕ
	              |
	              |ВЫБРАТЬ
	              |	-ХозрасчетныйОбороты.СуммаОборотДт
	              |ИЗ
	              |	РегистрБухгалтерии.Хозрасчетный.Обороты(&ДатаНач, &ДатаКон, Период, Счет В ИЕРАРХИИ (&СчетаВычетаИзДоходов), , Организация = &Организация, , ) КАК ХозрасчетныйОбороты
	              |
	              |ОБЪЕДИНИТЬ ВСЕ
	              |
	              |ВЫБРАТЬ
	              |	ХозрасчетныйОбороты.СуммаОборотКт
	              |ИЗ
	              |	РегистрБухгалтерии.Хозрасчетный.Обороты(&ДатаНач, &ДатаКон, Период, Счет В ИЕРАРХИИ (&СчетаВычетаИзДоходов), , Организация = &Организация, КорСчет В ИЕРАРХИИ (&СчетаНалогов), ) КАК ХозрасчетныйОбороты";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Объект.ВыручкаПрошлогоГода = 0;
	Пока Выборка.Следующий() Цикл
		Объект.ВыручкаПрошлогоГода = Объект.ВыручкаПрошлогоГода + Выборка.ВыручкаПрошлогоГода;
	КонецЦикла;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ БСП

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

#КонецОбласти