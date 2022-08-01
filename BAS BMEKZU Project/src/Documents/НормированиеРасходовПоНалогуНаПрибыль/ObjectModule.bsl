#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Выполняет движения по регистрам.
//
Процедура ДвиженияПоРегистрам(СтруктураШапкиДокумента, ТаблицаПоСтатьям, Отказ, Заголовок)
	
	// получим сумму текущих отличий в затратах по счет КЗ
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ДатаНач", НачалоГода(Дата));
	Запрос.УстановитьПараметр("ДатаКон", Новый Граница(МоментВремени(), ВидГраницы.Исключая));
	
	Запрос.УстановитьПараметр("НормируемыеСтатьи", ТаблицаПоСтатьям.ВыгрузитьКолонку("Статья"));
	Запрос.УстановитьПараметр("СчетКЗ", ПланыСчетов.Хозрасчетный.КорректировкиНормируемыхЗатратНУ);
		
	Запрос.УстановитьПараметр("СтатьиНалоговыхДеклараций", ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.СтатьиНалоговыхДеклараций);
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ХозрасчетныйОбороты.НалоговоеНазначение КАК НалоговоеНазначениеДоходовИЗатрат,
	               |	ХозрасчетныйОбороты.СуммаНУОборотДт КАК СуммаПревышения,
	               |	ХозрасчетныйОбороты.Субконто1 КАК Статья
	               |ИЗ
	               |	РегистрБухгалтерии.Хозрасчетный.Обороты(
	               |			&ДатаНач,
	               |			&ДатаКон,
	               |			Период,
	               |			Счет = &СчетКЗ,
	               |			&СтатьиНалоговыхДеклараций,
	               |			Организация = &Организация
	               |				И Субконто1 В (&НормируемыеСтатьи),
	               |			,
	               |			) КАК ХозрасчетныйОбороты";
	
	ТекДанные = Запрос.Выполнить().Выгрузить();				   
	
	СтруктураОтбора = Новый Структура("Статья, НалоговоеНазначениеДоходовИЗатрат");
	Для каждого СтрокаТаблицы Из ТаблицаПоСтатьям Цикл
	    Если СтрокаТаблицы.НалоговоеНазначениеДоходовИЗатрат = Справочники.НалоговыеНазначенияАктивовИЗатрат.НКУ_НеХозДеятельность Тогда
			// суммы по этому НН всегда должны быть равны 0
			Продолжить;
		КонецЕсли;
		
		СтруктураОтбора.Статья = СтрокаТаблицы.Статья;
		СтруктураОтбора.НалоговоеНазначениеДоходовИЗатрат = СтрокаТаблицы.НалоговоеНазначениеДоходовИЗатрат;
		
		ТекДанныеПоСтатье_НН = ТекДанные.НайтиСтроки(СтруктураОтбора);
		Если ТекДанныеПоСтатье_НН.Количество() = 0 Тогда
			ТекСумма = 0;
		Иначе	
		    ТекСумма = ТекДанныеПоСтатье_НН[0].СуммаПревышения;
		КонецЕсли;
		
		// При построении декларации итоговая сумма затрат это сумма по статье по счетам затрат + сумма отличий по счету КЗ
		СуммаПроводки = СтрокаТаблицы.СуммаВПределелахНорм - СтрокаТаблицы.СуммаОборот - ТекСумма;
		
		Если СуммаПроводки = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		// делаем "оборотные движения" чтобы не закрывать остатки
		Проводка = Движения.Хозрасчетный.Добавить();
		Проводка.Активность  = Истина;
		Проводка.Период		 = Дата;
		Проводка.Организация  = Организация;
		Проводка.Регистратор = Ссылка;
		
		Проводка.СуммаНУДт = СуммаПроводки;
		Проводка.СуммаНУКт = СуммаПроводки;
		
		Проводка.СчетДт = ПланыСчетов.Хозрасчетный.КорректировкиНормируемыхЗатратНУ;
		Проводка.СчетКт = ПланыСчетов.Хозрасчетный.КорректировкиНормируемыхЗатратНУ;
		
		Проводка.НалоговоеНазначениеДт = СтрокаТаблицы.НалоговоеНазначениеДоходовИЗатрат;
		Проводка.НалоговоеНазначениеКт = СтрокаТаблицы.НалоговоеНазначениеДоходовИЗатрат;
		
		БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, 1, СтрокаТаблицы.Статья);
		БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, 1, СтрокаТаблицы.Статья);
		
	КонецЦикла;

КонецПроцедуры // ДвиженияПоРегистрам()

// Выгружает результат запроса в табличную часть, добавляет ей необходимые колонки для проведения.
//
// Параметры: 
//  РезультатЗапросаПоТоварам - результат запроса по табличной части "Товары",
//  СтруктураШапкиДокумента   - выборка по результату запроса по шапке документа.
//
// Возвращаемое значение:
//  Сформированная таблиица значений.
//
Функция ПодготовитьТаблицуСтатей(РезультатЗапросаПоСтатьям, СтруктураШапкиДокумента, ПогрешностиОкругления)

	ТаблицаСтатей = РезультатЗапросаПоСтатьям.Выгрузить();
	
	Возврат ТаблицаСтатей;

КонецФункции // ПодготовитьТаблицуСтатей()
  
// Проверяет правильность заполнения строк табличной части "Статьи".
//
// Параметры: 
//  Отказ                   - флаг отказа в проведении.
//
Процедура ПроверитьЗаполнениеТабличнойЧастиСтатьи(Отказ)

	КоличествоСтрокВТЧ = Статьи.Количество();
	
	Для Уровень1 = 1 По КоличествоСтрокВТЧ Цикл
		
		Префикс = "Статьи[" + Формат(Уровень1 - 1, "ЧН=0; ЧГ=") + "].";
		
		Если Статьи[Уровень1- 1].СуммаОборот < Статьи[Уровень1- 1].СуммаВПределелахНорм Тогда
		
			Поле = Префикс + "СуммаВПределелахНорм";
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='В строке ""%1"" сумма в пределах норм превышает сумму зарегистрированных затрат!';uk='У рядку ""%1"" сума у межах норми перевищує суму зареєстрованих витрат!'"), Уровень1);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
		
		КонецЕсли;
		
		Для Уровень2 = Уровень1 + 1 По КоличествоСтрокВТЧ Цикл
			
			Если  Статьи[Уровень1- 1].Статья = Статьи[Уровень2- 1].Статья 
				И Статьи[Уровень1- 1].НалоговоеНазначениеДоходовИЗатрат = Статьи[Уровень2- 1].НалоговоеНазначениеДоходовИЗатрат  Тогда
			
			    Поле = Префикс + "Статья";
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='В строках ""%1"" и  ""%2"" указаны одинаковые статьи и налоговые назначения затрат!';uk='У рядках ""%1"" та  ""%2"" зазначені однакові статті та податкові призначення витрат!'"), Уровень1, Уровень2);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
				
			КонецЕсли;
			
		
		КонецЦикла;
	
	КонецЦикла; 
		
КонецПроцедуры // ПроверитьЗаполнениеТабличнойЧастиТовары()

// Процедура формирует таблицы документа.
//
Процедура ПодготовитьТаблицыДокумента(СтруктураШапкиДокумента, ТаблицаПоСтатьям, Отказ, Заголовок) Экспорт
	
	ПогрешностиОкругления     = Новый Соответствие;

	// Получим необходимые данные для проведения и проверки заполенения данные по табличной части "Товары".
	СтруктураПолей = Новый Структура();
	СтруктураПростыхПолей = Новый Структура;
	СтруктураСложныхПолей = Новый Структура;
	
	СтруктураПолей.Вставить("Статья",        		  "Статья");
	СтруктураПолей.Вставить("НалоговоеНазначениеДоходовИЗатрат",   "НалоговоеНазначениеДоходовИЗатрат");
	СтруктураПолей.Вставить("СуммаОборот",   		  "СуммаОборот");
	СтруктураПолей.Вставить("СуммаВПределелахНорм",   "СуммаВПределелахНорм");
	
	РезультатЗапросаПоСтатьям = ОбщегоНазначенияРед12.СформироватьЗапросПоТабличнойЧасти(ЭтотОбъект, "Статьи", СтруктураПолей, СтруктураПростыхПолей, СтруктураСложныхПолей);
	
	// Подготовим таблицу товаров для проведения.
	ТаблицаПоСтатьям = ПодготовитьТаблицуСтатей(РезультатЗапросаПоСтатьям, СтруктураШапкиДокумента, ПогрешностиОкругления);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура - обработчик события "ОбработкаПроведения".
//
Процедура ОбработкаПроведения(Отказ, Режим)
	
	Перем ТаблицаПоСтатьям;
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА
	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;

	// Сформируем структуру реквизитов шапки документа.
	СтруктураШапкиДокумента = ОбщегоНазначенияРед12.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);

	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначенияБПВызовСервера.ПредставлениеДокументаПриПроведении(Ссылка);

	ПодготовитьТаблицыДокумента(СтруктураШапкиДокумента, ТаблицаПоСтатьям, Отказ, Заголовок);
	
	Если Не Отказ Тогда
		ДвиженияПоРегистрам(СтруктураШапкиДокумента, ТаблицаПоСтатьям, Отказ, Заголовок);
	КонецЕсли;

	ПроведениеСервер.ПодготовитьНаборыЗаписейКЗаписиДвижений(ЭтотОбъект);
	
КонецПроцедуры // ОбработкаПроведения()

Процедура ОбработкаУдаленияПроведения(Отказ)

	ПроведениеСервер.ПодготовитьНаборыЗаписейКОтменеПроведения(ЭтотОбъект);
	Движения.Записать();

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПроверитьЗаполнениеТабличнойЧастиСтатьи(Отказ);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);

КонецПроцедуры


Процедура ПриКопировании(ОбъектКопирования)

	Дата = НачалоДня(ОбщегоНазначенияБП.ПолучитьРабочуюДату());
	Ответственный = Пользователи.ТекущийПользователь();

КонецПроцедуры

#КонецЕсли
