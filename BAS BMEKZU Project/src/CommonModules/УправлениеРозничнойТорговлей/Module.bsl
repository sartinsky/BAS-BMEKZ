// Определяет есть ли в данном документе склад - неавтоматизированная торговая точка,
// для которого надо указывать цену в рознице.
//
// Параметры: 
//  ДокументОбъект     - объект редактируемого документа.
//
// Возвращаемое значение:
//  Ссылка на розничный склад, если нет розничного склада, то Неопределено.
//
Функция ЕстьНеавтоматизированныйРозничныйСкладДокумента(ДокументОбъект) Экспорт

	МетаданныеДокумента = ДокументОбъект.Метаданные();

	Если ОбщегоНазначенияБП.ЕстьРеквизитДокумента("СкладПолучатель", МетаданныеДокумента) Тогда
		Склад = ДокументОбъект.СкладПолучатель;

	ИначеЕсли ОбщегоНазначенияБП.ЕстьРеквизитДокумента("Склад", МетаданныеДокумента) Тогда
		Склад = ДокументОбъект.Склад;

	Иначе
		Возврат Неопределено; // Нет склада, будем считать, что не розничный.

	КонецЕсли;

	Если Склад.ТипСклада = Перечисления.ТипыСкладов.НеавтоматизированнаяТорговаяТочка Тогда
		Возврат Склад;
	Иначе
		Возврат Неопределено; // Нет розничного склада.

	КонецЕсли;

КонецФункции // ЕстьНеавтоматизированныйРозничныйСкладДокумента()

// Определяет наличие розничного склада в переданной ТЧ.
//
// Параметры:
//  ТаблицаТоваров - таблица значений или ТЧ.
//  ИмяКолонкиСклад - название колонки, содержащей склад.
//  ИмяКолонкиВидСклада - название колонки, содержащей вид склада.
//
// Возвращаемое значение:
//  Булево - Истина, если в переданной ТЧ есть розничный склад.
//
Функция ОпределитьНаличиеРозничногоСклада(ТаблицаТоваров, ИмяКолонкиСклад, ИмяКолонкиВидСклада) Экспорт

	Если ТаблицаТоваров.Колонки.Найти(ИмяКолонкиСклад) = Неопределено
	 Или ТаблицаТоваров.Колонки.Найти(ИмяКолонкиВидСклада) = Неопределено Тогда
		ЕстьРозничныйСклад = Ложь;
	Иначе
		ЕстьРозничныйСклад = (ТаблицаТоваров.Найти(Перечисления.ТипыСкладов.РозничныйМагазин, ИмяКолонкиВидСклада) <> Неопределено);
	КонецЕсли;

	Возврат ЕстьРозничныйСклад;

КонецФункции // ОпределитьНаличиеРозничногоСклада()

// Выполняет запрос по продажным ценам по переданным параметрам.
//
// Параметры:
//  ДатаЦен - дата, на которую нужно получить цены.
//  СписокСкладов - список складов, по которым нужно получить цены.
//  СписокНоменклатуры - список номенклатуры, для которой нужно получить цены.
//
// Возвращаемое значение:
//  РезультатЗапроса - результат выполненого запроса по продажным ценам.
//
Функция СформироватьЗапросПоПродажнымЦенам(ДатаЦен, Валюта, СписокНоменклатуры, ТипЦенРозничнойТорговли) Экспорт

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Дата",					 ДатаЦен);
	Запрос.УстановитьПараметр("Валюта", 				 Валюта);
	Запрос.УстановитьПараметр("СписокНоменклатуры", 	 СписокНоменклатуры);
	Запрос.УстановитьПараметр("ТипЦенРозничнойТорговли", ТипЦенРозничнойТорговли);

	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ЦеныПродажные.Номенклатура КАК Номенклатура,
	|	ЦеныПродажные.Цена КАК Цена
	|ИЗ
	|	РегистрСведений.ЦеныНоменклатуры.СрезПоследних(
	|			&Дата,
	|			Номенклатура В (&СписокНоменклатуры)
	|				И Валюта = &Валюта) КАК ЦеныПродажные
	|ГДЕ
	|	ЦеныПродажные.ТипЦен = &ТипЦенРозничнойТорговли";
	
	Запрос.Текст = ТекстЗапроса;

	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросПоПродажнымЦенам()


// Функция выполняет поиск первой, удовлетворяющей условию поика, строки табличной части.
//
// Параметры:
//  ТабличнаяЧасть - табличная часть документа, в которой осуществляется поиск,
//  СтруктураОтбора - структура - задает условие поиска.
//
// Возвращаемое значение: 
//  Строка табличной части - найденная строка табличной части,
//  Неопределено           - строка табличной части не найдена.
//
Функция НайтиСтрокуТабЧасти(ТабличнаяЧасть, СтруктураОтбора) Экспорт

	СтрокаТабличнойЧасти = Неопределено;
	МассивНайденныхСтрок = ТабличнаяЧасть.НайтиСтроки(СтруктураОтбора);
	Если МассивНайденныхСтрок.Количество() > 0 Тогда

		// Нашли. Вернем первую найденную строку.
		СтрокаТабличнойЧасти = МассивНайденныхСтрок[0];
	КонецЕсли;

	Возврат СтрокаТабличнойЧасти;

КонецФункции // НайтиСтрокуТабЧасти()

// Процедура заполняет в переданной ТЧ колонку "СуммаПродажная".
//
// Параметры:
//  ТаблицаТоваров - таблица значений или ТЧ, в которой нужно колонку "СуммаПродажная" заполнить.
//  ТаблицаПоЦенам - таблица значений, содержащая продажные цены.
//  ИмяКолонкиВидСклада - название колонки, содержащей вид склада.
//
Процедура ЗаполнитьКолонкуСуммаПродажная(ТаблицаТоваров, ТаблицаПоЦенам, ИмяКолонкиВидСклада = Неопределено, ИмяКолонкиКоличество = "Количество") Экспорт

	СтруктураПоискаЦены = Новый Структура;
	ВидСкладаРозничный = Перечисления.ТипыСкладов.РозничныйМагазин;

	Для Каждого СтрокаТаблицы Из ТаблицаТоваров Цикл
		Если ИмяКолонкиВидСклада = Неопределено
		 Или СтрокаТаблицы[ИмяКолонкиВидСклада] = ВидСкладаРозничный Тогда
			
			СтруктураПоискаЦены.Вставить("Номенклатура", СтрокаТаблицы.Номенклатура);
			
			СтрокаЦен = НайтиСтрокуТабЧасти(ТаблицаПоЦенам, СтруктураПоискаЦены);
			Если СтрокаЦен <> Неопределено Тогда
				СтрокаТаблицы.СуммаПродажная = - СтрокаЦен.Цена * СтрокаТаблицы[ИмяКолонкиКоличество];
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры // ЗаполнитьКолонкуСуммаПродажная()
