#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область Печать

// Формирует печатные формы
//
// Параметры:
//  (входные)
//    МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//    ПараметрыПечати - Структура - дополнительные настройки печати;
//  (выходные)
//   КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы
//   ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                             представление - имя области в которой был выведен объект;
//   ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Печать") Тогда
		МодульУправлениеПечатью = ОбщегоНазначения.ОбщийМодуль("УправлениеПечатью");
		МодульУправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
				КоллекцияПечатныхФорм,
				"ПроизводственныйКалендарь", НСтр("ru='Производственный календарь';uk='Виробничий календар'"),
				РегистрыСведений.ИНАГРО_РегламентированныйПроизводственныйКалендарь.ПечатнаяФормаПроизводственногоКалендаря(ПараметрыПечати),
				,
				"РегистрСведений.ИНАГРО_РегламентированныйПроизводственныйКалендарь.ПФ_MXL_ПроизводственныйКалендарь");
	КонецЕсли;
	
КонецПроцедуры

Функция ПечатнаяФормаПроизводственногоКалендаря(ПараметрыПодготовкиПечатнойФормы) Экспорт
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ГОД(ДанныеКалендаря.ДатаКалендаря) КАК ГодКалендаря,
	|	КВАРТАЛ(ДанныеКалендаря.ДатаКалендаря) КАК КварталКалендаря,
	|	МЕСЯЦ(ДанныеКалендаря.ДатаКалендаря) КАК МесяцКалендаря,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ДанныеКалендаря.ДатаКалендаря) КАК КалендарныеДни,
	|	ДанныеКалендаря.ВидДня КАК ВидДня
	|ИЗ
	|	РегистрСведений.ИНАГРО_РегламентированныйПроизводственныйКалендарь КАК ДанныеКалендаря
	|ГДЕ
	|	ДанныеКалендаря.Год = &Год
	|
	|СГРУППИРОВАТЬ ПО
	|	ДанныеКалендаря.ВидДня,
	|	ГОД(ДанныеКалендаря.ДатаКалендаря),
	|	КВАРТАЛ(ДанныеКалендаря.ДатаКалендаря),
	|	МЕСЯЦ(ДанныеКалендаря.ДатаКалендаря)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ГодКалендаря,
	|	КварталКалендаря,
	|	МесяцКалендаря
	|ИТОГИ ПО
	|	ГодКалендаря,
	|	КварталКалендаря,
	|	МесяцКалендаря";
	
	//ПроизводственныйКалендарь = ПараметрыПодготовкиПечатнойФормы.ПроизводственныйКалендарь;
	НомерГода = ПараметрыПодготовкиПечатнойФормы.НомерГода;
	
	Макет = РегистрыСведений.ИНАГРО_РегламентированныйПроизводственныйКалендарь.ПолучитьМакет("ПФ_MXL_ПроизводственныйКалендарь");
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	ЗаголовокПечати = Макет.ПолучитьОбласть("Заголовок");
	//ЗаголовокПечати.Параметры.ПроизводственныйКалендарь = ПроизводственныйКалендарь;
	ЗаголовокПечати.Параметры.Год = Формат(НомерГода, "ЧГ=");
	ТабличныйДокумент.Вывести(ЗаголовокПечати);
	
	// Начальные значения, независимо от результата выполнения запроса
	РабочееВремя40Год = 0;
	РабочееВремя36Год = 0;
	РабочееВремя24Год = 0;
	
	ВидыНерабочихДней = Новый Массив;
	ВидыНерабочихДней.Добавить(Перечисления.ИНАГРО_ВидыДнейПроизводственногоКалендаря.Суббота);
	ВидыНерабочихДней.Добавить(Перечисления.ИНАГРО_ВидыДнейПроизводственногоКалендаря.Воскресенье);
	ВидыНерабочихДней.Добавить(Перечисления.ИНАГРО_ВидыДнейПроизводственногоКалендаря.Праздник);
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Год", НомерГода);
	Результат = Запрос.Выполнить();
	
	ВыборкаПоГоду = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаПоГоду.Следующий() Цикл
		
		ВыборкаПоКварталу = ВыборкаПоГоду.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаПоКварталу.Следующий() Цикл
			НомерКвартала = Макет.ПолучитьОбласть("Квартал");
			НомерКвартала.Параметры.НомерКвартала = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='%1 квартал';uk='%1 квартал'"), ВыборкаПоКварталу.КварталКалендаря);
			ТабличныйДокумент.Вывести(НомерКвартала);
			
			ШапкаКвартала = Макет.ПолучитьОбласть("ШапкаКвартала");
			ТабличныйДокумент.Вывести(ШапкаКвартала);
			
			КалендарныеДниКв = 0;
			РабочееВремя40Кв = 0;
			РабочееВремя36Кв = 0;
			РабочееВремя24Кв = 0;
			РабочиеДниКв	 = 0;
			ВыходныеДниКв	 = 0;
			
			Если ВыборкаПоКварталу.КварталКалендаря = 1 
				Или ВыборкаПоКварталу.КварталКалендаря = 3 Тогда
				КалендарныеДниПолугодие1	= 0;
				РабочееВремя40Полугодие1	= 0;
				РабочееВремя36Полугодие1	= 0;
				РабочееВремя24Полугодие1	= 0;
				РабочиеДниПолугодие1		= 0;
				ВыходныеДниПолугодие1		= 0;
			КонецЕсли;
			
			Если ВыборкаПоКварталу.КварталКалендаря = 1 Тогда
				КалендарныеДниГод	= 0;
				РабочееВремя40Год	= 0;
				РабочееВремя36Год	= 0;
				РабочееВремя24Год	= 0;
				РабочиеДниГод		= 0;
				ВыходныеДниГод		= 0;
			КонецЕсли;
			
			ВыборкаПоМесяцу = ВыборкаПоКварталу.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока ВыборкаПоМесяцу.Следующий() Цикл
				
				ВыходныеДни		= 0;
				РабочееВремя40	= 0;
				РабочееВремя36	= 0;
				РабочееВремя24	= 0;
				КалендарныеДни	= 0;
				РабочиеДни		= 0;
				ВыборкаПоВидуДня = ВыборкаПоМесяцу.Выбрать(ОбходРезультатаЗапроса.Прямой);
				
				Пока ВыборкаПоВидуДня.Следующий() Цикл
					Если ВыборкаПоВидуДня.ВидДня = Перечисления.ИНАГРО_ВидыДнейПроизводственногоКалендаря.Суббота 
						Или ВыборкаПоВидуДня.ВидДня = Перечисления.ИНАГРО_ВидыДнейПроизводственногоКалендаря.Воскресенье
						Или ВыборкаПоВидуДня.ВидДня = Перечисления.ИНАГРО_ВидыДнейПроизводственногоКалендаря.Праздник Тогда
						 ВыходныеДни = ВыходныеДни + ВыборкаПоВидуДня.КалендарныеДни
					 ИначеЕсли ВыборкаПоВидуДня.ВидДня = Перечисления.ИНАГРО_ВидыДнейПроизводственногоКалендаря.Рабочий Тогда 
						 РабочееВремя40 = РабочееВремя40 + ВыборкаПоВидуДня.КалендарныеДни * 8;
						 РабочееВремя36 = РабочееВремя36 + ВыборкаПоВидуДня.КалендарныеДни * 36 / 5;
						 РабочееВремя24 = РабочееВремя24 + ВыборкаПоВидуДня.КалендарныеДни * 24 / 5;
						 РабочиеДни 	= РабочиеДни + ВыборкаПоВидуДня.КалендарныеДни;
					 ИначеЕсли ВыборкаПоВидуДня.ВидДня = Перечисления.ИНАГРО_ВидыДнейПроизводственногоКалендаря.Предпраздничный Тогда
						 РабочееВремя40 = РабочееВремя40 + ВыборкаПоВидуДня.КалендарныеДни * 7;
						 РабочееВремя36 = РабочееВремя36 + ВыборкаПоВидуДня.КалендарныеДни * 36 / 5 - 1;
						 РабочееВремя24 = РабочееВремя24 + ВыборкаПоВидуДня.КалендарныеДни * 24 / 5 - 1;
						 РабочиеДни		= РабочиеДни + ВыборкаПоВидуДня.КалендарныеДни;
					 КонецЕсли;
					 КалендарныеДни = КалендарныеДни + ВыборкаПоВидуДня.КалендарныеДни;
				КонецЦикла;
				
				КалендарныеДниКв = КалендарныеДниКв + КалендарныеДни;
				РабочееВремя40Кв = РабочееВремя40Кв + РабочееВремя40;
				РабочееВремя36Кв = РабочееВремя36Кв + РабочееВремя36;
				РабочееВремя24Кв = РабочееВремя24Кв + РабочееВремя24;
				РабочиеДниКв	 = РабочиеДниКв 	+ РабочиеДни;
				ВыходныеДниКв	 = ВыходныеДниКв	+ ВыходныеДни;
				
				КалендарныеДниПолугодие1 = КалендарныеДниПолугодие1 + КалендарныеДни;
				РабочееВремя40Полугодие1 = РабочееВремя40Полугодие1 + РабочееВремя40;
				РабочееВремя36Полугодие1 = РабочееВремя36Полугодие1 + РабочееВремя36;
				РабочееВремя24Полугодие1 = РабочееВремя24Полугодие1 + РабочееВремя24;
				РабочиеДниПолугодие1	 = РабочиеДниПолугодие1 	+ РабочиеДни;
				ВыходныеДниПолугодие1	 = ВыходныеДниПолугодие1	+ ВыходныеДни;
				
				КалендарныеДниГод = КалендарныеДниГод + КалендарныеДни;
				РабочееВремя40Год = РабочееВремя40Год + РабочееВремя40;
				РабочееВремя36Год = РабочееВремя36Год + РабочееВремя36;
				РабочееВремя24Год = РабочееВремя24Год + РабочееВремя24;
				РабочиеДниГод	 = РабочиеДниГод 	+ РабочиеДни;
				ВыходныеДниГод	 = ВыходныеДниГод	+ ВыходныеДни;
				
				КолонкаМесяца = Макет.ПолучитьОбласть("КолонкаМесяца");
				КолонкаМесяца.Параметры.ВыходныеДни = ВыходныеДни;
				КолонкаМесяца.Параметры.РабочееВремя40 	= РабочееВремя40;
				КолонкаМесяца.Параметры.РабочееВремя36 	= РабочееВремя36;
				КолонкаМесяца.Параметры.РабочееВремя24 	= РабочееВремя24;
				КолонкаМесяца.Параметры.КалендарныеДни 	= КалендарныеДни;
				КолонкаМесяца.Параметры.РабочиеДни 		= РабочиеДни;
				КолонкаМесяца.Параметры.ИмяМесяца 		= Формат(Дата(НомерГода, ВыборкаПоМесяцу.МесяцКалендаря, 1), "ДФ='ММММ'");
				ТабличныйДокумент.Присоединить(КолонкаМесяца);
				
			КонецЦикла;
			КолонкаМесяца = Макет.ПолучитьОбласть("КолонкаМесяца");
			КолонкаМесяца.Параметры.ВыходныеДни 	= ВыходныеДниКв;
			КолонкаМесяца.Параметры.РабочееВремя40 	= РабочееВремя40Кв;
			КолонкаМесяца.Параметры.РабочееВремя36 	= РабочееВремя36Кв;
			КолонкаМесяца.Параметры.РабочееВремя24 	= РабочееВремя24Кв;
			КолонкаМесяца.Параметры.КалендарныеДни 	= КалендарныеДниКв;
			КолонкаМесяца.Параметры.РабочиеДни 		= РабочиеДниКв;
			КолонкаМесяца.Параметры.ИмяМесяца 		= СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='%1 квартал';uk='%1 квартал'"), ВыборкаПоКварталу.КварталКалендаря);
			ТабличныйДокумент.Присоединить(КолонкаМесяца);
			
			Если ВыборкаПоКварталу.КварталКалендаря = 2 
				Или ВыборкаПоКварталу.КварталКалендаря = 4 Тогда 
				КолонкаМесяца = Макет.ПолучитьОбласть("КолонкаМесяца");
				КолонкаМесяца.Параметры.ВыходныеДни 	= ВыходныеДниПолугодие1;
				КолонкаМесяца.Параметры.РабочееВремя40 	= РабочееВремя40Полугодие1;
				КолонкаМесяца.Параметры.РабочееВремя36 	= РабочееВремя36Полугодие1;
				КолонкаМесяца.Параметры.РабочееВремя24 	= РабочееВремя24Полугодие1;
				КолонкаМесяца.Параметры.КалендарныеДни 	= КалендарныеДниПолугодие1;
				КолонкаМесяца.Параметры.РабочиеДни 		= РабочиеДниПолугодие1;
				КолонкаМесяца.Параметры.ИмяМесяца 		= СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru='%1 полугодие';uk='%1 півріччя'"), ВыборкаПоКварталу.КварталКалендаря / 2);
				ТабличныйДокумент.Присоединить(КолонкаМесяца);
			КонецЕсли;
			
		КонецЦикла;
		
		КолонкаМесяца = Макет.ПолучитьОбласть("КолонкаМесяца");
		КолонкаМесяца.Параметры.ВыходныеДни 	= ВыходныеДниГод;
		КолонкаМесяца.Параметры.РабочееВремя40 	= РабочееВремя40Год;
		КолонкаМесяца.Параметры.РабочееВремя36 	= РабочееВремя36Год;
		КолонкаМесяца.Параметры.РабочееВремя24 	= РабочееВремя24Год;
		КолонкаМесяца.Параметры.КалендарныеДни 	= КалендарныеДниГод;
		КолонкаМесяца.Параметры.РабочиеДни 		= РабочиеДниГод;
		КолонкаМесяца.Параметры.ИмяМесяца 		= СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='%1 год';uk='%1 рік'"), Формат(ВыборкаПоГоду.ГодКалендаря, "ЧГ="));
		ТабличныйДокумент.Присоединить(КолонкаМесяца);
		
	КонецЦикла;
	
	КолонкаМесяца = Макет.ПолучитьОбласть("Среднемесячный");
	КолонкаМесяца.Параметры.РабочееВремя40 	= РабочееВремя40Год;
	КолонкаМесяца.Параметры.РабочееВремя36 	= РабочееВремя36Год;
	КолонкаМесяца.Параметры.РабочееВремя24 	= РабочееВремя24Год;
	КолонкаМесяца.Параметры.ИмяМесяца 		= СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='%1 год';uk='%1 рік'"), Формат(НомерГода, "ЧГ="));
	ТабличныйДокумент.Вывести(КолонкаМесяца);
	
	КолонкаМесяца = Макет.ПолучитьОбласть("КолонкаМесяцаСр");
	КолонкаМесяца.Параметры.РабочееВремя40 	= Формат(РабочееВремя40Год / 12, "ЧДЦ=2; ЧГ=0");
	КолонкаМесяца.Параметры.РабочееВремя36 	= Формат(РабочееВремя36Год / 12, "ЧДЦ=2; ЧГ=0");
	КолонкаМесяца.Параметры.РабочееВремя24 	= Формат(РабочееВремя24Год / 12, "ЧДЦ=2; ЧГ=0");
	КолонкаМесяца.Параметры.ИмяМесяца 		= НСтр("ru='Среднемесячное количество';uk='Середньомісячна кількість'");
	ТабличныйДокумент.Присоединить(КолонкаМесяца);
	
	Возврат ТабличныйДокумент;
	
КонецФункции

#КонецОбласти

#Область ПрограммныйИнтерфейс

// Заполняет ресурсы "Пятидневка", "Шестидневка" и "КалендарныеДни"
Функция ЗаполнитьРесурсыЗаписиРегистра(ЗаписьРегистра)
	
	// празничный день	
	Если ЗаписьРегистра.ВидДня = Перечисления.ИНАГРО_ВидыДнейПроизводственногоКалендаря.Праздник Тогда
		ЗаписьРегистра.КалендарныеДни = 0;
	Иначе
		ЗаписьРегистра.КалендарныеДни = 1;
	КонецЕсли;
	
КонецФункции 

// Функция читает данные производственного календаря из регистра
//
// Параметры:
//	НомерГода							- Номер года, за который необходимо прочитать производственный календарь.
// 
// Возвращаемое значение: 
// Результат - результат запроса
//
Функция ДанныеПроизводственногоКалендаря(НомерГода) Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("ТекущийГод",	НомерГода);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеПроизводственногоКалендаря.ДатаКалендаря,
	|	ДанныеПроизводственногоКалендаря.ВидДня,
	|	ДанныеПроизводственногоКалендаря.ДатаПереноса
	|ИЗ
	|	РегистрСведений.ИНАГРО_РегламентированныйПроизводственныйКалендарь КАК ДанныеПроизводственногоКалендаря
	|ГДЕ
	|	ДанныеПроизводственногоКалендаря.Год = &ТекущийГод";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

// Функция составляет список всевозможных видов дней производственного календаря 
// по метаданным перечисления ВидыДнейПроизводственногоКалендаря
//
// Возвращаемое значение:
//	СписокВидовДня - список значений, содержащий значение перечисления 
//  					и его синоним в качестве представления
//
Функция СписокВидовДня() Экспорт
	
	СписокВидовДня = Новый СписокЗначений;
	
	Для Каждого МетаданныеВидаДней Из Метаданные.Перечисления.ИНАГРО_ВидыДнейПроизводственногоКалендаря.ЗначенияПеречисления Цикл
		СписокВидовДня.Добавить(Перечисления.ИНАГРО_ВидыДнейПроизводственногоКалендаря[МетаданныеВидаДней.Имя], МетаданныеВидаДней.Синоним);
	КонецЦикла;
	
	Возврат СписокВидовДня;
	
КонецФункции

// Функция определяет соответствие видов дня производственного календаря и цвета оформления
// этого дня в поле календаря
//
// Возвращаемое значение:
//	ЦветаОформления - соответствие видов дня и цветов оформления
//
Функция ЦветаОформленияВидовДнейПроизводственногоКалендаря() Экспорт
	
	ЦветаОформления = Новый Соответствие;
	
	ЦветаОформления.Вставить(Перечисления.ИНАГРО_ВидыДнейПроизводственногоКалендаря.Рабочий,			ЦветаСтиля.ВидДняПроизводственногоКалендаряРабочийЦвет);
	ЦветаОформления.Вставить(Перечисления.ИНАГРО_ВидыДнейПроизводственногоКалендаря.Суббота,			ЦветаСтиля.ВидДняПроизводственногоКалендаряСубботаЦвет);
	ЦветаОформления.Вставить(Перечисления.ИНАГРО_ВидыДнейПроизводственногоКалендаря.Воскресенье,		ЦветаСтиля.ВидДняПроизводственногоКалендаряВоскресеньеЦвет);
	ЦветаОформления.Вставить(Перечисления.ИНАГРО_ВидыДнейПроизводственногоКалендаря.Предпраздничный,	ЦветаСтиля.ВидДняПроизводственногоКалендаряПредпраздничныйЦвет);
	ЦветаОформления.Вставить(Перечисления.ИНАГРО_ВидыДнейПроизводственногоКалендаря.Праздник,			ЦветаСтиля.ВидДняПроизводственногоКалендаряПраздникЦвет);
	
	Возврат ЦветаОформления;
	
КонецФункции

// Функция возвращает результат заполнения производственного календаря по умолчанию
// Параметры:
//
// НомерГода - Дата -  дата в которой находиться номер года.
//
// Возвращаемое значение:
// ДанныеПроизводственногоКалендаря - Строка - строка с данными производственного календаря.
// 
Функция РезультатЗаполненияПроизводственногоКалендаряПоУмолчанию(НомерГода) Экспорт
	
	ДлинаСуток = 24 * 3600;
	
	ДанныеПроизводственногоКалендаря = Новый ТаблицаЗначений;
	ДанныеПроизводственногоКалендаря.Колонки.Добавить("ДатаКалендаря", Новый ОписаниеТипов("Дата"));
	ДанныеПроизводственногоКалендаря.Колонки.Добавить("ВидДня", Новый ОписаниеТипов("ПеречислениеСсылка.ИНАГРО_ВидыДнейПроизводственногоКалендаря"));
	ДанныеПроизводственногоКалендаря.Колонки.Добавить("ДатаПереноса", Новый ОписаниеТипов("Дата"));
	
	// Если есть данные в макете - используем их
	ПредопределенныеДанные = ДанныеПроизводственныхКалендарейИзМакета().НайтиСтроки(
								Новый Структура("Год", НомерГода));
	Если ПредопределенныеДанные.Количество() > 0 Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(ПредопределенныеДанные, ДанныеПроизводственногоКалендаря);
		Возврат ДанныеПроизводственногоКалендаря;
	КонецЕсли;
	
	// Если нет - заполняем праздники и переносы
	ПраздничныеДни = ПраздничныеДниПроизводственногоКалендаря(НомерГода);
	
	ВидыДней = Новый Соответствие;
	
	ДатаДня = Дата(НомерГода, 1, 1);
	Пока ДатаДня <= Дата(НомерГода, 12, 31) Цикл
		// "Непраздничный" день - определяем в соответствии с днем недели
		НомерДняНедели = ДеньНедели(ДатаДня);
		Если НомерДняНедели <= 5 Тогда
			ВидыДней.Вставить(ДатаДня, Перечисления.ИНАГРО_ВидыДнейПроизводственногоКалендаря.Рабочий);
		ИначеЕсли НомерДняНедели = 6 Тогда
			ВидыДней.Вставить(ДатаДня, Перечисления.ИНАГРО_ВидыДнейПроизводственногоКалендаря.Суббота);
		ИначеЕсли НомерДняНедели = 7 Тогда
			ВидыДней.Вставить(ДатаДня, Перечисления.ИНАГРО_ВидыДнейПроизводственногоКалендаря.Воскресенье);
		КонецЕсли;
		ДатаДня = ДатаДня + ДлинаСуток;
	КонецЦикла;
	
	// При совпадении выходного и нерабочего праздничного дней 
	// выходной день переносится на следующий после праздничного рабочий день 
	
	ПереносыДней = Новый Соответствие;
	Для Каждого СтрокаТаблицы Из ПраздничныеДни Цикл
		ПраздничныйДень = СтрокаТаблицы.Дата;
		Если ВидыДней[ПраздничныйДень] <> Перечисления.ИНАГРО_ВидыДнейПроизводственногоКалендаря.Рабочий 
			И СтрокаТаблицы.ПереноситьВыходной Тогда
			// Если праздничный день выпадает на выходной, 
			// и выходной, на который выпадает этот праздник, переносится - 
			// переносим выходной на ближайший рабочий день
			ДатаДня = ПраздничныйДень;
			Пока Истина Цикл
				ДатаДня = ДатаДня + ДлинаСуток;
				Если ВидыДней[ДатаДня] = Перечисления.ИНАГРО_ВидыДнейПроизводственногоКалендаря.Рабочий 
					И ПраздничныеДни.Найти(ДатаДня, "Дата") = Неопределено Тогда
					ВидыДней.Вставить(ДатаДня, ВидыДней[ПраздничныйДень]);
					ПереносыДней.Вставить(ДатаДня, ПраздничныйДень);
					ПереносыДней.Вставить(ПраздничныйДень, ДатаДня);
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		ВидыДней.Вставить(ПраздничныйДень, Перечисления.ИНАГРО_ВидыДнейПроизводственногоКалендаря.Праздник);
		// Отметим как предпраздничный день, 
		// рабочий день непосредственно предшествующий праздничному дню
		ДатаПредпраздничногоДня = ПраздничныйДень - ДлинаСуток;
		Если ВидыДней[ДатаПредпраздничногоДня] = Перечисления.ИНАГРО_ВидыДнейПроизводственногоКалендаря.Рабочий 
			И ПраздничныеДни.Найти(ДатаПредпраздничногоДня, "Дата") = Неопределено 
			И Год(ДатаПредпраздничногоДня) = Год(ПраздничныйДень) Тогда
			ВидыДней.Вставить(ДатаПредпраздничногоДня, Перечисления.ИНАГРО_ВидыДнейПроизводственногоКалендаря.Предпраздничный);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого КлючИЗначение Из ВидыДней Цикл
		НоваяСтрока = ДанныеПроизводственногоКалендаря.Добавить();
		НоваяСтрока.ДатаКалендаря = КлючИЗначение.Ключ;
		НоваяСтрока.ВидДня = КлючИЗначение.Значение;
		ДатаПереноса = ПереносыДней[НоваяСтрока.ДатаКалендаря];
		Если ДатаПереноса <> Неопределено Тогда
			НоваяСтрока.ДатаПереноса = ДатаПереноса;
		КонецЕсли;
	КонецЦикла;
	
	ДанныеПроизводственногоКалендаря.Сортировать("ДатаКалендаря");
	
	Возврат ДанныеПроизводственногоКалендаря;
	
КонецФункции
	
// Процедура записывает данные одного производственного календаря за 1 год
//
// Параметры:
//	НомерГода							- Номер года, за который необходимо записать производственный календарь
//	ДанныеПроизводственногоКалендаря	- таблица значений, в которой хранятся сведения о виде дня на каждую дату календаря
//
//
Процедура ЗаписатьДанныеПроизводственногоКалендаря(НомерГода, ДанныеПроизводственногоКалендаря) Экспорт
	
	// Очистим старые данные за год
	НаборЗаписей = РегистрыСведений.ИНАГРО_РегламентированныйПроизводственныйКалендарь.СоздатьНаборЗаписей();
	НаборЗаписей.Записывать = Истина;
	НаборЗаписей.Отбор.Год.Значение		 = НомерГода;
	НаборЗаписей.Отбор.Год.Использование = Истина;
	НаборЗаписей.Прочитать();
	
	ЕстьЗаписиВРегистре = НаборЗаписей.Количество() > 0;
	
	НаборЗаписейЗаДеньПоВремени	= РегистрыСведений.ИНАГРО_ГрафикиРаботыПоВидамВремени.СоздатьНаборЗаписей();
	НаборЗаписейЗаДеньПоВремени.Отбор.Дата.Использование = Истина;
	// Запишем новые данные за год
	Если ЕстьЗаписиВРегистре Тогда
		
		НаборЗаписей.Очистить();
	КонецЕсли;
		
	Для Каждого СтрокаТаблицы Из ДанныеПроизводственногоКалендаря Цикл
		
		НоваяЗаписьРегистра = НаборЗаписей.Добавить();
		НоваяЗаписьРегистра.ДатаКалендаря = СтрокаТаблицы.ДатаКалендаря;
		НоваяЗаписьРегистра.Год			  = Год(СтрокаТаблицы.ДатаКалендаря);
		НоваяЗаписьРегистра.ВидДня		  = СтрокаТаблицы.ВидДня;
		
		// Установим ресурс "КалендарныеДни"
		ЗаполнитьРесурсыЗаписиРегистра(НоваяЗаписьРегистра);
		
		// Синхронизируем внесенные изменения с регистром "ГрафикиРаботыПоВидамВремени"
		НаборЗаписейЗаДеньПоВремени.Отбор.Дата.Значение		 = СтрокаТаблицы.ДатаКалендаря;
		НаборЗаписейЗаДеньПоВремени.Прочитать();
		
		Для Каждого ЗаписьДня Из НаборЗаписейЗаДеньПоВремени Цикл
			ЗаписьДня.ПроизводственныйКалендарьКалендарныеДни = НоваяЗаписьРегистра.КалендарныеДни;
			ЗаписьДня.Месяц = НачалоМесяца(СтрокаТаблицы.ДатаКалендаря);
		КонецЦикла; 
		
		НаборЗаписейЗаДеньПоВремени.Записать();
		
	КонецЦикла; 
	// запишем набор записей
	НаборЗаписей.Записать();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция заполняет массив дат праздничных дней по производственному календарю 
// для конкретного календарного года
//
Функция ПраздничныеДниПроизводственногоКалендаря(НомерГода)
	
	ПраздничныеДни = Новый ТаблицаЗначений;
	ПраздничныеДни.Колонки.Добавить("Дата", Новый ОписаниеТипов("Дата"));
	ПраздничныеДни.Колонки.Добавить("ПереноситьВыходной", Новый ОписаниеТипов("Булево"));
	
	// 1 января - Новый год
	ДобавитьПраздничныйДень(ПраздничныеДни, "01.01", НомерГода);
			
	// 7 января - Рождество
	ДобавитьПраздничныйДень(ПраздничныеДни, "07.01", НомерГода);
	
	// 8 марта - Международный женский день
	ДобавитьПраздничныйДень(ПраздничныеДни, "08.03", НомерГода);
	
	// 1,2 мая - День солидарности трудящихся
	ДобавитьПраздничныйДень(ПраздничныеДни, "01.05", НомерГода);
	Если НомерГода <= 2017 Тогда
		ДобавитьПраздничныйДень(ПраздничныеДни, "02.05", НомерГода);
	КонецЕсли;	
	
	// 9 мая - День Победы
	ДобавитьПраздничныйДень(ПраздничныеДни, "09.05", НомерГода);
	
	// 28 июня - День Конституции
	ДобавитьПраздничныйДень(ПраздничныеДни, "28.06", НомерГода);
	
	// 24 августа - День Независимости
	ДобавитьПраздничныйДень(ПраздничныеДни, "24.08", НомерГода);
	
	// 14 октября - День защитника Украины
	ДобавитьПраздничныйДень(ПраздничныеДни, "14.10", НомерГода);
	
	Если НомерГода >= 2017 Тогда
		// 25 декабря - Рождество (католическое)
		ДобавитьПраздничныйДень(ПраздничныеДни, "25.12", НомерГода);
	КонецЕсли;
	
	// Переходящие религиозные праздники
	ДниПасхи = Новый Соответствие;
	ДниПасхи.Вставить(2004, "11.04");
	ДниПасхи.Вставить(2005, "01.05");
	ДниПасхи.Вставить(2006, "23.04");
	ДниПасхи.Вставить(2007, "08.04");
	ДниПасхи.Вставить(2008, "27.04");
	ДниПасхи.Вставить(2009, "20.04");
	ДниПасхи.Вставить(2010, "04.04");
	ДниПасхи.Вставить(2011, "24.04");
	ДниПасхи.Вставить(2012, "15.04");
	ДниПасхи.Вставить(2013, "05.05");
	ДниПасхи.Вставить(2014, "20.04");
	ДниПасхи.Вставить(2015, "12.04");
	ДниПасхи.Вставить(2016, "01.05");
	ДниПасхи.Вставить(2017, "16.04");
	ДниПасхи.Вставить(2018, "08.04");
	ДниПасхи.Вставить(2019, "28.04");
	ДниПасхи.Вставить(2020, "19.04");
	ДниПасхи.Вставить(2021, "02.05");
	
	ДобавитьПасхуТроицу(ПраздничныеДни, ДниПасхи[НомерГода], НомерГода);
	
	// Если вдруг два праздника выпадает на один день
	ПраздничныеДни.Свернуть("Дата,ПереноситьВыходной");
	ПраздничныеДни.Сортировать("Дата");
	
	Возврат ПраздничныеДни;
	
КонецФункции

Процедура ДобавитьПасхуТроицу(ПраздничныеДни, ПраздничныйДень, НомерГода, ПереноситьВыходной = Истина)
	
	ДеньМесяц = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ПраздничныйДень, ".");
	
	Если ДеньМесяц.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Пасха = Дата(НомерГода, ДеньМесяц[1], ДеньМесяц[0]);
	Троица = Пасха + 49*86400;
	
	НоваяСтрока = ПраздничныеДни.Добавить();
	НоваяСтрока.Дата = Пасха;
	НоваяСтрока.ПереноситьВыходной = ПереноситьВыходной;
	НоваяСтрока = ПраздничныеДни.Добавить();
	НоваяСтрока.Дата = Троица;
	НоваяСтрока.ПереноситьВыходной = ПереноситьВыходной;
	
КонецПроцедуры

Процедура ДобавитьПраздничныйДень(ПраздничныеДни, ПраздничныйДень, НомерГода, ПереноситьВыходной = Истина)
	
	ДеньМесяц = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ПраздничныйДень, ".");
	
	НоваяСтрока = ПраздничныеДни.Добавить();
	НоваяСтрока.Дата = Дата(НомерГода, ДеньМесяц[1], ДеньМесяц[0]);
	НоваяСтрока.ПереноситьВыходной = ПереноситьВыходной;
	
КонецПроцедуры

// Функция преобразовывает данные производственных календарей, 
//  поставляемые в виде макета в конфигурации
//
// Параметры:
//	- нет
//
// Возвращаемое значение - таблица значений с колонками
//	Подробнее см. комментарий к функции ДанныеПроизводственныхКалендарейИзXML
//
Функция ДанныеПроизводственныхКалендарейИзМакета()
	
	ТекстовыйДокумент = РегистрыСведений.ИНАГРО_РегламентированныйПроизводственныйКалендарь.ПолучитьМакет("ДанныеПроизводственныхКалендарей");
	
	Возврат ДанныеПроизводственныхКалендарейИзXML(ТекстовыйДокумент.ПолучитьТекст());
	
КонецФункции

// Функция преобразовывает данные производственных календарей, 
//  представленные в виде XML
//
// Параметры:
//	- XML - документ с данными
//
// Возвращаемое значение - таблица значений с колонками:
//	- КодПроизводственногоКалендаря
//	- ВидДня
//	- Год
//	- Дата
//	- ДатаПереноса
//
Функция ДанныеПроизводственныхКалендарейИзXML(Знач XML)
	
	ТаблицаДанных = Новый ТаблицаЗначений;
	ТаблицаДанных.Колонки.Добавить("КодПроизводственногоКалендаря", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(2)));
	ТаблицаДанных.Колонки.Добавить("ВидДня", Новый ОписаниеТипов("ПеречислениеСсылка.ИНАГРО_ВидыДнейПроизводственногоКалендаря"));
	ТаблицаДанных.Колонки.Добавить("Год", Новый ОписаниеТипов("Число"));
	ТаблицаДанных.Колонки.Добавить("Дата", Новый ОписаниеТипов("Дата"));
	ТаблицаДанных.Колонки.Добавить("ДатаПереноса", Новый ОписаниеТипов("Дата"));
	
	КлассификаторТаблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(XML).Данные;
	
	Для Каждого СтрокаКлассификатора Из КлассификаторТаблица Цикл
		НоваяСтрока = ТаблицаДанных.Добавить();
		НоваяСтрока.КодПроизводственногоКалендаря = СтрокаКлассификатора.Calendar;
		НоваяСтрока.ВидДня	= Перечисления.ИНАГРО_ВидыДнейПроизводственногоКалендаря[СтрокаКлассификатора.DayType];
		НоваяСтрока.Год		= Число(СтрокаКлассификатора.Year);
		НоваяСтрока.Дата	= Дата(СтрокаКлассификатора.Date);
		Если ЗначениеЗаполнено(СтрокаКлассификатора.SwapDate) Тогда
			НоваяСтрока.ДатаПереноса = Дата(СтрокаКлассификатора.SwapDate);
		КонецЕсли;
	КонецЦикла;
	
	Возврат ТаблицаДанных;
	
КонецФункции

#КонецОбласти

#КонецЕсли