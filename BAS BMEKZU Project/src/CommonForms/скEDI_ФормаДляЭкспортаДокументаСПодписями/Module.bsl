
&НаКлиенте
Процедура КаталогСохраненияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	лДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	лДиалогВыбораФайла.Каталог = КаталогСохранения;
	лДиалогВыбораФайла.МножественныйВыбор = Ложь;
	лДиалогВыбораФайла.Заголовок = НСтр("ru = 'Выберите каталог для сохранения файлов'; uk = 'Виберіть каталог для збереження файлів'");

	Если лДиалогВыбораФайла.Выбрать() Тогда
		КаталогСохранения = лДиалогВыбораФайла.Каталог;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СохранитьФайл(Команда)
	Если Не СохранятьТелоДокумента и НЕ СохранятьИзображениеДокумента и НЕ СохранятьВложенныеФайлы и НЕ СохранятьИзображениеДокументаPDF и НЕ СохранятьИзображениеДокументаPNG Тогда
		Сообщить(НСтр("ru = 'Не выбрано Что экспортировать!'; uk = 'Не вибрано Що експортувати!'"));
		Возврат;
	КонецЕсли;
	Если СохранятьТелоДокумента или СохранятьИзображениеДокумента или СохранятьВложенныеФайлы Тогда
		Если Не СохранятьВ_P7S и НЕ СохранятьВ_CADES Тогда
			Сообщить(НСтр("ru = 'Не выбран формат экспорта!'; uk = 'Не вибрано формат експорту!'"));
			Возврат;
		КонецЕсли;
	КонецЕсли;
	Если КаталогСохранения = "" Тогда
		Сообщить(НСтр("ru = 'Не выбран Каталог!'; uk = 'Не вибрано Каталог!'"));
		Возврат;
	КонецЕсли;
	
	СтруктураНастройки = Новый Структура;
	СтруктураНастройки.Вставить("КаталогСохранения", КаталогСохранения);
	СтруктураНастройки.Вставить("ЧтоСохраняем", ЧтоСохраняем);
	СтруктураНастройки.Вставить("ИмяФайла", ИмяФайла);
	СтруктураНастройки.Вставить("НомерФайла", НомерФайла);
	СтруктураНастройки.Вставить("СохранятьТелоДокумента", СохранятьТелоДокумента);
	СтруктураНастройки.Вставить("СохранятьИзображениеДокумента", СохранятьИзображениеДокумента);
	СтруктураНастройки.Вставить("СохранятьВложенныеФайлы", СохранятьВложенныеФайлы);
	СтруктураНастройки.Вставить("СохранятьВ_P7S", СохранятьВ_P7S);
	СтруктураНастройки.Вставить("СохранятьВ_CADES", СохранятьВ_CADES);
	СтруктураНастройки.Вставить("СохранятьИзображениеДокументаPDF", СохранятьИзображениеДокументаPDF);
	СтруктураНастройки.Вставить("СохранятьИзображениеДокументаPNG", СохранятьИзображениеДокументаPNG);
	СтруктураНастройки.Вставить("ЖурналРабочегоСтола", ЖурналРабочегоСтола);
	Закрыть(СтруктураНастройки);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	пЧтоСохраняем = Неопределено;
	Если Параметры.Свойство("ЧтоСохраняем", пЧтоСохраняем) Тогда
		Если пЧтоСохраняем = "СписокЭлектронныхДокументов" Тогда
			ЧтоСохраняем = пЧтоСохраняем;
			//Заголовок = НСтр("ru = 'Экспорт сожержимого списка Электронных документов'; uk = 'Експорт вмісту списку Електронних документів'");
			
			Элементы.ИмяФайла.Видимость = Ложь;
			СохранятьТелоДокумента = Ложь;//Истина;
			СохранятьИзображениеДокумента = Ложь;//Истина;
			СохранятьВ_CADES = Ложь;
			СохранятьВ_P7S = Истина;
			
			Элементы.СохранятьВ_P7S.Заголовок = НСтр("ru = 'Экспорт документа в формате P7S'; uk = 'Експорт документу у форматі P7S'");
			Элементы.СохранятьВ_CADES.Заголовок = НСтр("ru = 'Экспорт документа с подписями (CADES)'; uk = 'Експорт документу з підписами (CADES)'");
			
			Элементы.ГруппаЭкспорнВизуальногоОтображения.Видимость = Истина;
		ИначеЕсли пЧтоСохраняем = "ЭлектронныйДокумент" Тогда
			ЧтоСохраняем = пЧтоСохраняем;
			//Заголовок = НСтр("ru = 'Экспорт сожержимого Электронного документа'; uk = 'Експорт вмісту Електронного документу'");
			
			Элементы.СохранятьВложенныеФайлы.Видимость = Ложь;
			СохранятьТелоДокумента = Ложь;//Истина;
			СохранятьИзображениеДокумента = Истина;
			СохранятьВ_CADES = Ложь;
			СохранятьВ_P7S = Истина;
			
			Элементы.СохранятьВ_P7S.Заголовок = НСтр("ru = 'Экспорт документа в формате P7S'; uk = 'Експорт документу у форматі P7S'");
			Элементы.СохранятьВ_CADES.Заголовок = НСтр("ru = 'Экспорт документа с подписями (CADES)'; uk = 'Експорт документу з підписами (CADES)'");
			
			Элементы.ГруппаЭкспорнВизуальногоОтображения.Видимость = Истина;
		ИначеЕсли пЧтоСохраняем = "НалоговыйЭлектронныйДокумент" Тогда
			ЧтоСохраняем = пЧтоСохраняем;
			//Заголовок = НСтр("ru = 'Экспорт сожержимого Электронного документа'; uk = 'Експорт вмісту Електронного документу'");
			
			Элементы.СохранятьВложенныеФайлы.Видимость = Ложь;
			СохранятьТелоДокумента = Истина;
			СохранятьИзображениеДокумента = Ложь;
			Элементы.СохранятьИзображениеДокумента.Доступность = Ложь;
			СохранятьВ_CADES = Истина;
			СохранятьВ_P7S = Ложь;
			
			Элементы.СохранятьВ_P7S.Заголовок = НСтр("ru = 'Экспорт документа в формате P7S'; uk = 'Експорт документу у форматі P7S'");
			Элементы.СохранятьВ_CADES.Заголовок = НСтр("ru = 'Экспорт документа с подписями (CADES)'; uk = 'Експорт документу з підписами (CADES)'");
			Элементы.ГруппаЭкспорнВизуальногоОтображения.Видимость = Истина;
		ИначеЕсли пЧтоСохраняем = "ВложеныйФайл" Тогда
			ЧтоСохраняем = пЧтоСохраняем;
			//Заголовок = НСтр("ru = 'Экспорт вложеного файла'; uk = 'Експорт вкладеного файлу'");
			
			Элементы.ГруппаФлажкиЧтоСохранять.Видимость = Ложь;
			СохранятьВ_CADES = Ложь;
			СохранятьВ_P7S = Истина;
			СохранятьВложенныеФайлы = Истина;
			
			Элементы.СохранятьВ_P7S.Заголовок = НСтр("ru = 'Экспорт вложеного файла в формате P7S'; uk = 'Експорт вкладеного файлу у форматі P7S'");
			Элементы.СохранятьВ_CADES.Заголовок = НСтр("ru = 'Экспорт вложеного файла с подписями (CADES)'; uk = 'Експорт вкладеного файлу з підписами (CADES)'");
			
			Элементы.ГруппаЭкспорнВизуальногоОтображения.Видимость = Ложь;
		Иначе
			Отказ = Истина;
			Возврат;
		КонецЕсли;
	Иначе
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	пИмяФайла = Неопределено;
	Если Параметры.Свойство("ИмяФайла", пИмяФайла) Тогда
		ИмяФайла = пИмяФайла;
	КонецЕсли;
	пНомерФайла = Неопределено;
	Если Параметры.Свойство("НомерФайла", пНомерФайла) Тогда
		НомерФайла = пНомерФайла;
	КонецЕсли;
	лЖурналРабочегоСтола = Неопределено;
	Если Параметры.Свойство("ЖурналРабочегоСтола", лЖурналРабочегоСтола) Тогда
		ЖурналРабочегоСтола = лЖурналРабочегоСтола;
	КонецЕсли;
КонецПроцедуры



