#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПроцедурыИФункцииПечати

Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

	// Изменение цен номенклатуры
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПереченьЦен";
	КомандаПечати.Представление = НСтр("ru='Перечень цен';uk='Перелік цін'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.СписокФорм    = "ФормаДокумента,ФормаСписка";
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Реестр";
	КомандаПечати.Представление = НСтр("ru='Реестр документов';uk='Реєстр документів'");
	КомандаПечати.ЗаголовокФормы= НСтр("ru='Реестр документов ""Встановлення цін на послуги""';uk='Реєстр документів ""Установка цен на услуги""'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм    = "ФормаСписка";
	КомандаПечати.Порядок       = 100;

КонецПроцедуры		

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	// Устанавливаем признак доступности печати покомплектно.
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
	// Проверяем, нужно ли для макета СчетЗаказа формировать табличный документ.
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПереченьЦен") Тогда
		
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ПереченьЦен", НСтр("ru='Перечень цен';uk='Перелік цін'"), 
		ПечатьДокумента(МассивОбъектов, ОбъектыПечати, ПараметрыВывода), , "Документ.ИНАГРО_УстановкаЦенНаУслуги.ПФ_MXL_ИзменениеЦен", ,Истина);
		
	КонецЕсли; 	

КонецПроцедуры

Функция ПечатьДокумента(МассивОбъектов, ОбъектыПечати, ПараметрыВывода)
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ИНАГРО_УстановкаЦенНаУслуги_ИзменениеЦен";
	
	Макет = ПолучитьМакет("ПФ_MXL_ИзменениеЦен");
	
	КодЯзыкаПечать = ПараметрыВывода.КодЯзыкаДляМногоязычныхПечатныхФорм;
	Макет.КодЯзыкаМакета = КодЯзыкаПечать;
	
	ПервыйДокумент = Истина;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ИНАГРО_УстановкаЦенНаУслуги.Ссылка,
		|	ИНАГРО_УстановкаЦенНаУслуги.ВерсияДанных,
		|	ИНАГРО_УстановкаЦенНаУслуги.ПометкаУдаления,
		|	ИНАГРО_УстановкаЦенНаУслуги.Номер,
		|	ИНАГРО_УстановкаЦенНаУслуги.Дата,
		|	ИНАГРО_УстановкаЦенНаУслуги.Проведен,
		|	ИНАГРО_УстановкаЦенНаУслуги.ВидВзаиморасчетов,
		|	ИНАГРО_УстановкаЦенНаУслуги.ДоговорКонтрагента,
		|	ИНАГРО_УстановкаЦенНаУслуги.Комментарий,
		|	ИНАГРО_УстановкаЦенНаУслуги.Контрагент,
		|	ИНАГРО_УстановкаЦенНаУслуги.ОписаниеДвиженияФормы36,
		|	ИНАГРО_УстановкаЦенНаУслуги.Организация,
		|	ИНАГРО_УстановкаЦенНаУслуги.Ответственный,
		|	ИНАГРО_УстановкаЦенНаУслуги.Урожай,
		|	ИНАГРО_УстановкаЦенНаУслуги.УдалитьИнформация,
		|	ИНАГРО_УстановкаЦенНаУслуги.УдалитьНеПроводитьНулевыеЗначения,
		|	ИНАГРО_УстановкаЦенНаУслуги.Организация.Наименование,
		|	ИНАГРО_УстановкаЦенНаУслуги.Организация.НаименованиеПолное,
		|	ИНАГРО_УстановкаЦенНаУслуги.Ответственный.Представление
		|ИЗ
		|	Документ.ИНАГРО_УстановкаЦенНаУслуги КАК ИНАГРО_УстановкаЦенНаУслуги
		|ГДЕ
		|	ИНАГРО_УстановкаЦенНаУслуги.Ссылка В(&МассивОбъектов)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ИНАГРО_УстановкаЦенНаУслугиТовары.Ссылка,
		|	ИНАГРО_УстановкаЦенНаУслугиТовары.НомерСтроки,
		|	ИНАГРО_УстановкаЦенНаУслугиТовары.ВидКультуры,
		|	ИНАГРО_УстановкаЦенНаУслугиТовары.Услуга,
		|	ИНАГРО_УстановкаЦенНаУслугиТовары.ЦенаСтарая,
		|	ИНАГРО_УстановкаЦенНаУслугиТовары.ЦенаНовая КАК Цена,
		|	ИНАГРО_УстановкаЦенНаУслугиТовары.Услуга.НаименованиеПолное КАК Товар,
		|	ИНАГРО_УстановкаЦенНаУслугиТовары.Услуга.БазоваяЕдиницаИзмерения КАК ЕдиницаИзмеренияПредставление
		|ИЗ
		|	Документ.ИНАГРО_УстановкаЦенНаУслуги.Товары КАК ИНАГРО_УстановкаЦенНаУслугиТовары
		|ГДЕ
		|	ИНАГРО_УстановкаЦенНаУслугиТовары.Ссылка В(&МассивОбъектов)";
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	ВыборкаШапка = МассивРезультатов[0].Выбрать();
	
	ВыборкаТЧ    = МассивРезультатов[1].Выгрузить();
	
	Пока ВыборкаШапка.Следующий() Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабДокумент.ВысотаТаблицы + 1;
		
		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		ОбластьМакета.Параметры.ТекстЗаголовка = ОбщегоНазначенияБПВызовСервера.СформироватьЗаголовокДокумента(ВыборкаШапка.Ссылка, НСтр("ru='Изменение цен услуг';uk='Зміна цін послуг'",КодЯзыкаПечать),КодЯзыкаПечать);
		ТабДокумент.Вывести(ОбластьМакета);
		
		ОбластьШапкаНоменклатура   = Макет.ПолучитьОбласть("ШапкаТаблицы|Номенклатура");
		ОбластьШапкаТипЦен         = Макет.ПолучитьОбласть("ШапкаТаблицы|Цена");
		ОбластьСтрокаНоменклатура  = Макет.ПолучитьОбласть("Строка|Номенклатура");
		ОбластьСтрокаТипЦен        = Макет.ПолучитьОбласть("Строка|Цена");
		ОбластьПодвалНоменклатура  = Макет.ПолучитьОбласть("Подписи|Номенклатура");
		ОбластьПодвалТипЦен        = Макет.ПолучитьОбласть("Подписи|Цена");
		
		// Выведем шапку
		ТабДокумент.Вывести(ОбластьШапкаНоменклатура);
		
		ТабДокумент.Присоединить(ОбластьШапкаТипЦен);
		
		// Выведем таблицу
		ТабТЧ = ВыборкаТЧ.Скопировать(Новый Структура("Ссылка",ВыборкаШапка.Ссылка));
		
		Для Каждого Стр Из ТабТЧ Цикл
			ОбластьСтрокаНоменклатура.Параметры.Заполнить(Стр);
			ТабДокумент.Вывести(ОбластьСтрокаНоменклатура);
			ОбластьСтрокаТипЦен.Параметры.Заполнить(Стр);
			ТабДокумент.Присоединить(ОбластьСтрокаТипЦен);
		КонецЦикла;
		
		// Выведем подвал
		ОбластьПодвалНоменклатура.Параметры.Заполнить(ВыборкаШапка);
		ТабДокумент.Вывести(ОбластьПодвалНоменклатура);
		ТабДокумент.Присоединить(ОбластьПодвалТипЦен);
		
		ТекОбласть = ТабДокумент.Области.ОтветственныйПредставление;
		
		ОбластьОтветственного = ТабДокумент.Область(ТекОбласть.Низ, 14, ТекОбласть.Низ, Мин(ТабДокумент.ШиринаТаблицы, 29));
		ОбластьОтветственного.Объединить();
		ОбластьОтветственного.ГраницаСнизу            = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная);
		ОбластьОтветственного.ГоризонтальноеПоложение = ГоризонтальноеПоложение.Право;
		
	КонецЦикла;
	
	Возврат ТабДокумент;

КонецФункции 

Функция ПолучитьДополнительныеРеквизитыДляРеестра() Экспорт
	
	Результат = Новый Структура;	
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти 

#КонецЕсли
