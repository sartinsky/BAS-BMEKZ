
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если ПользователиКлиентСервер.ЭтоСеансВнешнегоПользователя() Тогда
		Возврат;
	КонецЕсли;
		
	КонтейнерСостояний = Новый Структура;
	КонтейнерСостояний.Вставить("СостояниеПоиска", ПолнотекстовыйПоискСервер.СостояниеПолнотекстовогоПоиска());
	// Возможные значения:
	// "ПоискРазрешен"
	// "ВыполняетсяОбновлениеИндекса"
	// "ВыполняетсяСлияниеИндекса"
	// "ТребуетсяОбновлениеИндекса"
	// "ОшибкаНастройкиПоиска"
	// "ПоискЗапрещен".
	КонтейнерСостояний.Вставить("ИскатьВРазделах", Ложь);
	КонтейнерСостояний.Вставить("ОбластиПоиска", Новый СписокЗначений); // Идентификаторы объектов метаданных.
	КонтейнерСостояний.Вставить("ТекущаяПозиция", 0);
	КонтейнерСостояний.Вставить("Количество", 0);
	КонтейнерСостояний.Вставить("ПолноеКоличество", 0);
	КонтейнерСостояний.Вставить("КодОшибки", "");
	// Возможные значения:
	// "ОшибкаПоиска"
	// "СлишкомМногоРезультатов"
	// "НичегоНеНайдено"
	КонтейнерСостояний.Вставить("ОписаниеОшибки", "");
	КонтейнерСостояний.Вставить("РезультатыПоиска", Новый Массив); // см. ВыполнитьПолнотекстовыйПоиск.
	КонтейнерСостояний.Вставить("ИсторияПоиска", Новый Массив); // Список поисковых фраз.
	
	ЗагрузитьНастройкиИИсториюПоиска(КонтейнерСостояний);
	
	Если Не ПустаяСтрока(Параметры.ПереданнаяСтрокаПоиска) Тогда
		СтрокаПоиска = Параметры.ПереданнаяСтрокаПоиска;
		ПриВыполненииПоискаНаСервере(КонтейнерСостояний, СтрокаПоиска);
	КонецЕсли;
	
	ОбновитьИсториюПоиска(Элементы.СтрокаПоиска, КонтейнерСостояний);
	ОбластиПоискаПредставление = ПредставлениеОбластиПоиска(КонтейнерСостояний);
	ОбновитьДоступностьКнопокНавигации(Элементы.Следующие, Элементы.Предыдущие, КонтейнерСостояний);
	ИнформацияОНайденномПредставление = ПредставлениеИнформацииОНайденном(КонтейнерСостояний);
	HTMLСтраницаПредставление = ПредставлениеHTMLСтраницы(СтрокаПоиска, КонтейнерСостояний);
	СостояниеПоискаПредставление = ПредставлениеСостоянияПоиска(КонтейнерСостояний);
	ОбновитьВидимостьСостояниеПоиска(КонтейнерСостояний);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ПользователиКлиентСервер.ЭтоСеансВнешнегоПользователя() Тогда 
		Отказ = Истина;
		ПоказатьПредупреждение(, НСтр("ru='Недостаточно прав для выполнения поиска';uk='Недостатньо прав для виконання пошуку'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтрокаПоискаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	// Обход ошибки платформы.
#Если ВебКлиент Тогда
	Если Элементы.СтрокаПоиска.СписокВыбора.Количество() = 1 Тогда
		ВыбранноеЗначение = Элемент.ТекстРедактирования;
	КонецЕсли;
#КонецЕсли
	
	СтрокаПоиска = ВыбранноеЗначение;
	ПриВыполненииПоиска("ПерваяЧасть");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбластиПоискаПредставлениеНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОбластиПоиска   = КонтейнерСостояний.ОбластиПоиска;
	ИскатьВРазделах = КонтейнерСостояний.ИскатьВРазделах;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ОбластиПоиска",   ОбластиПоиска);
	ПараметрыОткрытия.Вставить("ИскатьВРазделах", ИскатьВРазделах);
	
	Оповещение = Новый ОписаниеОповещения("ПослеПолученияНастроекОбластиПоиска", ЭтотОбъект);
	
	ОткрытьФорму("Обработка.ПолнотекстовыйПоискВДанных.Форма.ВыборОбластиПоиска",
		ПараметрыОткрытия,,,,, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура HTMLТекстПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СсылкаHTML = ДанныеСобытия.Anchor;
	
	Если СсылкаHTML = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ПослеОткрытияНавигационнойСсылки", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ОткрытьНавигационнуюСсылку(СсылкаHTML.href, Оповещение);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьПоиск(Команда)
	
	ПриВыполненииПоиска("ПерваяЧасть");
	
КонецПроцедуры

&НаКлиенте
Процедура Предыдущие(Команда)
	
	ПриВыполненииПоиска("ПредыдущаяЧасть");
	
КонецПроцедуры

&НаКлиенте
Процедура Следующие(Команда)
	
	ПриВыполненииПоиска("СледующаяЧасть");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область СлужебныеОбработчикиСобытий

&НаКлиенте
Процедура ПослеПолученияНастроекОбластиПоиска(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		ПриУстановкеОбластиПоиска(Результат);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриУстановкеОбластиПоиска(НастройкиОбластиПоиска)
	
	СохранитьНастройкиПоиска(НастройкиОбластиПоиска.ИскатьВРазделах, НастройкиОбластиПоиска.ОбластиПоиска);
	
	ЗаполнитьЗначенияСвойств(КонтейнерСостояний, НастройкиОбластиПоиска,
		"ОбластиПоиска, ИскатьВРазделах");
	
	ОбластиПоискаПредставление = ПредставлениеОбластиПоиска(КонтейнерСостояний);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриВыполненииПоиска(НаправлениеПоиска)
	
	Если ПустаяСтрока(СтрокаПоиска) Тогда
		ПоказатьПредупреждение(, НСтр("ru='Введите, что нужно найти';uk='Введіть, що потрібно знайти'"));
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначенияСлужебныйКлиент.ЭтоНавигационнаяСсылка(СтрокаПоиска) Тогда
		ОбщегоНазначенияКлиент.ОткрытьНавигационнуюСсылку(СтрокаПоиска);
		СтрокаПоиска = "";
		Возврат;
	КонецЕсли;
	
	ПриВыполненииПоискаНаСервере(КонтейнерСостояний, СтрокаПоиска, НаправлениеПоиска);
	
	ПодключитьОбработчикОжидания("ПослеВыполненияПоиска", 0.1, Истина);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПриВыполненииПоискаНаСервере(КонтейнерСостояний, СтрокаПоиска, НаправлениеПоиска = "ПерваяЧасть")
	
	СохранитьСтрокуПоискаВИстории(СтрокаПоиска, КонтейнерСостояний.ИсторияПоиска);
	
	ПараметрыПоиска = ПолнотекстовыйПоискСервер.ПараметрыПоиска();
	ЗаполнитьЗначенияСвойств(ПараметрыПоиска, КонтейнерСостояний,
		"ТекущаяПозиция, ИскатьВРазделах, ОбластиПоиска");
	ПараметрыПоиска.СтрокаПоиска = СтрокаПоиска;
	ПараметрыПоиска.НаправлениеПоиска = НаправлениеПоиска;
	
	РезультатПоиска = ПолнотекстовыйПоискСервер.ВыполнитьПолнотекстовыйПоиск(ПараметрыПоиска);
	
	ЗаполнитьЗначенияСвойств(КонтейнерСостояний, РезультатПоиска, 
		"ТекущаяПозиция, Количество, ПолноеКоличество, КодОшибки, ОписаниеОшибки, РезультатыПоиска");
	
	КонтейнерСостояний.СостояниеПоиска = ПолнотекстовыйПоискСервер.СостояниеПолнотекстовогоПоиска();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыполненияПоиска()
	
	ОбновитьИсториюПоиска(Элементы.СтрокаПоиска, КонтейнерСостояний);
	ОбновитьДоступностьКнопокНавигации(Элементы.Следующие, Элементы.Предыдущие, КонтейнерСостояний);
	ИнформацияОНайденномПредставление = ПредставлениеИнформацииОНайденном(КонтейнерСостояний);
	HTMLСтраницаПредставление = ПредставлениеHTMLСтраницы(СтрокаПоиска, КонтейнерСостояний);
	СостояниеПоискаПредставление = ПредставлениеСостоянияПоиска(КонтейнерСостояний);
	ОбновитьВидимостьСостояниеПоиска(КонтейнерСостояний);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеОткрытияНавигационнойСсылки(ПриложениеЗапущено, Контекст) Экспорт
	
	Если Не ПриложениеЗапущено Тогда 
		ПоказатьПредупреждение(, НСтр("ru='Открытие объектов данного типа не предусмотрено';uk='Відкриття об''єктів даного типу не передбачено'"));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Представления

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьИсториюПоиска(Элемент, КонтейнерСостояний)
	
	ИсторияПоиска = КонтейнерСостояний.ИсторияПоиска;
	
	Если ТипЗнч(ИсторияПоиска) = Тип("Массив") Тогда
		Элемент.СписокВыбора.ЗагрузитьЗначения(ИсторияПоиска);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПредставлениеОбластиПоиска(КонтейнерСостояний)
	
	ИскатьВРазделах = КонтейнерСостояний.ИскатьВРазделах;
	ОбластиПоиска   = КонтейнерСостояний.ОбластиПоиска;
	
	УказаныОбластиПоиска = ОбластиПоиска.Количество() > 0;
	
	Если Не ИскатьВРазделах Или Не УказаныОбластиПоиска Тогда
		Возврат НСтр("ru='Везде';uk='Скрізь'");
	КонецЕсли;
	
	Если ОбластиПоиска.Количество() < 5 Тогда
		ПредставлениеОбластиПоиска = "";
		Для каждого Область Из ОбластиПоиска Цикл
			ОбъектМетаданных = ОбщегоНазначения.ОбъектМетаданныхПоИдентификатору(Область.Значение);
			ПредставлениеОбластиПоиска = ПредставлениеОбластиПоиска + ПредставлениеФормыСписка(ОбъектМетаданных) + ", ";
		КонецЦикла;
		Возврат Лев(ПредставлениеОбластиПоиска, СтрДлина(ПредставлениеОбластиПоиска) - 2);
	КонецЕсли;
	
	Возврат НСтр("ru='В выбранных разделах';uk='У вибраних розділах'");
	
КонецФункции

&НаСервереБезКонтекста
Функция ПредставлениеФормыСписка(ОбъектМетаданных)
	
	Если Не ПустаяСтрока(ОбъектМетаданных.РасширенноеПредставлениеСписка) Тогда
		Представление = ОбъектМетаданных.РасширенноеПредставлениеСписка;
	ИначеЕсли Не ПустаяСтрока(ОбъектМетаданных.ПредставлениеСписка) Тогда
		Представление = ОбъектМетаданных.ПредставлениеСписка;
	Иначе 
		Представление = ОбъектМетаданных.Представление();
	КонецЕсли;
	
	Возврат Представление;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьДоступностьКнопокНавигации(ЭлементКнопкиСледующие, ЭлементКнопкиПредыдущие, КонтейнерСостояний)
	
	Количество = КонтейнерСостояний.Количество;
	
	Если Количество = 0 Тогда
		ЭлементКнопкиСледующие.Доступность  = Ложь;
		ЭлементКнопкиПредыдущие.Доступность = Ложь;
	Иначе
		
		ПолноеКоличество = КонтейнерСостояний.ПолноеКоличество;
		ТекущаяПозиция   = КонтейнерСостояний.ТекущаяПозиция;
		
		ЭлементКнопкиСледующие.Доступность  = (ПолноеКоличество - ТекущаяПозиция) > Количество;
		ЭлементКнопкиПредыдущие.Доступность = (ТекущаяПозиция > 0);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПредставлениеИнформацииОНайденном(КонтейнерСостояний)
	
	Количество = КонтейнерСостояний.Количество;
	
	Если Количество <> 0 Тогда
		
		ТекущаяПозиция   = КонтейнерСостояний.ТекущаяПозиция;
		ПолноеКоличество = КонтейнерСостояний.ПолноеКоличество;
		
		Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Показаны %1 - %2 из %3';uk='Показані %1 - %2 з %3'"),
			Формат(ТекущаяПозиция + 1, "ЧН=0; ЧГ="),
			Формат(ТекущаяПозиция + Количество, "ЧН=0; ЧГ="),
			Формат(ПолноеКоличество, "ЧН=0; ЧГ="));
			
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПредставлениеHTMLСтраницы(СтрокаПоиска, КонтейнерСостояний)
	
	КодОшибки  = КонтейнерСостояний.КодОшибки;
	
	Если ПустаяСтрока(КодОшибки) Тогда 
		HTMLСтраница = НоваяHTMLСтраницаРезультата(КонтейнерСостояний);
	Иначе 
		HTMLСтраница = НоваяHTMLСтраницаОшибки(КонтейнерСостояний);
	КонецЕсли;
	
	Возврат HTMLСтраница;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция НоваяHTMLСтраницаРезультата(КонтейнерСостояний)
	
	ШаблонСтраницы = 
		"<html>
		|<head>
		|  <meta http-equiv=""Content-Type"" content=""text/html; charset=UTF-8"">
		|  <style type=""text/css"">
		|    html {
		|      overflow: auto;
		|    }
		|    body {
		|      margin: 10px;
		|      font-family: Arial, sans-serif;
		|      font-size: 10pt;
		|      overflow: auto;
		|      position: absolute;
		|      top: 0;
		|      left: 0;
		|      bottom: 0;
		|      right: 0;
		|    }
		|    div.main {
		|      overflow: auto;
		|      height: 100%;
		|    }
		|    div.presentation {
		|      font-size: 11pt;
		|    }
		|    div.textPortion {
		|      padding-bottom: 16px;
		|    }
		|    span.bold {
		|      font-weight: bold;
		|    }
		|    ol li {
		|      color: #B3B3B3;
		|    }
		|    ol li div {
		|      color: #333333;
		|    }
		|    a {
		|      text-decoration: none;
		|      color: #0066CC;
		|    }
		|    a:hover {
		|      text-decoration: underline;
		|    }
		|    .gray {
		|      color: #B3B3B3;
		|    }
		|  </style>
		|</head>
		|<body>
		|  <div class=""main"">
		|    <ol start=""%ТекущаяПозиция%"">
		|%Строки%
		|    </ol>
		|  </div>
		|</body>
		|</html>";
	
	ШаблонСтроки = 
		"      <li>
		|        <div class=""presentation""><a href=""%Ссылка%"">%Представление%</a></div>
		|        %ОписаниеHTML%
		|      </li>";
	
	ШаблонНеактивнойСтроки = 
		"      <li>
		|        <div class=""presentation""><a href=""#"" class=""gray"">%Представление%</a></div>
		|        %ОписаниеHTML%
		|      </li>";
	
	РезультатыПоиска = КонтейнерСостояний.РезультатыПоиска;
	ТекущаяПозиция   = КонтейнерСостояний.ТекущаяПозиция;
	
	Строки = "";
	
	Для каждого СтрокаРезультатаПоиска Из РезультатыПоиска Цикл 
		
		Ссылка        = СтрокаРезультатаПоиска.Ссылка;
		Представление = СтрокаРезультатаПоиска.Представление;
		ОписаниеHTML  = СтрокаРезультатаПоиска.ОписаниеHTML;
		
		Если Ссылка = "#" Тогда 
			Строка = ШаблонНеактивнойСтроки;
		Иначе 
			Строка = СтрЗаменить(ШаблонСтроки, "%Ссылка%", Ссылка);
		КонецЕсли;
		
		Строка = СтрЗаменить(Строка, "%Представление%", Представление);
		Строка = СтрЗаменить(Строка, "%ОписаниеHTML%",  ОписаниеHTML);
		
		Строки = Строки + Строка;
		
	КонецЦикла;
	
	HTMLСтраница = СтрЗаменить(ШаблонСтраницы, "%Строки%", Строки);
	HTMLСтраница = СтрЗаменить(HTMLСтраница  , "%ТекущаяПозиция%", ТекущаяПозиция + 1);
	
	Возврат HTMLСтраница;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция НоваяHTMLСтраницаОшибки(КонтейнерСостояний)
	
	ШаблонСтраницы = 
		"<html>
		|<head>
		|  <meta http-equiv=""Content-Type"" content=""text/html; charset=UTF-8"">
		|  <style type=""text/css"">
		|    html { 
		|      overflow:auto;
		|    }
		|    body {
		|      margin: 10px;
		|      font-family: Arial, sans-serif;
		|      font-size: 10pt;
		|      overflow: auto;
		|      position: absolute;
		|      top: 0;
		|      left: 0;
		|      bottom: 0;
		|      right: 0;
		|    }
		|    div.main {
		|      overflow: auto;
		|      height: 100%;
		|    }
		|    div.error {
		|      font-size: 12pt;
		|    }
		|    div.presentation {
		|      font-size: 11pt;
		|    }
		|    h3 {
		|      color: #009646
		|    }
		|    li {
		|      padding-bottom: 16px;
		|    }
		|    a {
		|      text-decoration: none;
		|      color: #0066CC;
		|    }
		|    a:hover {
		|      text-decoration: underline;
		|    }
		|  </style>
		|</head>
		|<body>
		|  <div class=""main"">
		|    <div class=""error"">%1</div>
		|    <p>%2</p>
		|  </div>
		|</body>
		|</html>";
	
	РекомендацииHTML = 
		НСтр("ru='<h3>Рекомендации:</h3>
            |<ul>
            |  %РекомендацияОбластиПоиска%
            |  %РекомендацияТекстЗапроса%
            |  <li>
            |    <b>Воспользуйтесь поиском по началу слова.</b><br>
            |    Используйте звездочку (*) в качестве окончания.<br>
            |    Например, поиск стро* найдет все документы, которые содержат слова, начинающиеся на стро - 
            |    Журнал ""Строительство и ремонт"", ""ООО СтройКомплект"" и.т.д.
            |  </li>
            |  <li>
            |    <b>Воспользуйтесь нечетким поиском.</b><br>
            |    Используйте решетку (#).<br>
            |    Например, Ромашка#2 найдет все документы, содержащие такие слова, которые отличаются от слова 
            |    Ромашка на одну или две буквы.
            |  </li>
            |</ul>
            |<div class ""presentation""><a href=""v8help://1cv8/QueryLanguageFullTextSearchInData"">Полное описание формата поисковых выражений</a></div>'
            |;uk='<h3>Рекомендації:</h3>
            |<ul>
            |  %РекомендацияОбластиПоиска%
            |  %РекомендацияТекстЗапроса%
            |  <li>
            |    <b>Скористайтесь пошуком по початку слова.</b><br>
            |    Введіть зірку (*) у якості закінчення.<br>
            |    Наприклад, пошук буд* знайде всі документи, які містять слова, які починаються на буд - 
            |    Журнал ""Будівництво та ремонт"", ""ТОВ Будкомплект"" і. т. д.
            |  </li>
            |  <li>
            |    <b>Скористайтесь нечітким пошуком.</b><br>
            |    Використовуйте решітку (#).<br>
            |    Наприклад, Ромашка#2 знайде всі документи, що містять такі слова, які відрізняються від слова 
            |    Ромашка на одну або дві букви.
            |  </li>
            |</ul>
            |<div class ""presentation""><a href=""v8help://1cv8/QueryLanguageFullTextSearchInData"">Повний опис формату пошукових виразів</a></div>'");
	
	ОписаниеОшибки  = КонтейнерСостояний.ОписаниеОшибки;
	КодОшибки       = КонтейнерСостояний.КодОшибки;
	ИскатьВРазделах = КонтейнерСостояний.ИскатьВРазделах;
	ОбластиПоиска   = КонтейнерСостояний.ОбластиПоиска;
	
	УказаныОбластиПоиска = ОбластиПоиска.Количество() > 0;
	
	РекомендацияОбластиПоискаHTML = "";
	РекомендацияТекстЗапросаHTML = "";
	
	Если КодОшибки = "НичегоНеНайдено" Тогда 
		
		Если ИскатьВРазделах И УказаныОбластиПоиска Тогда 
		
			РекомендацияОбластиПоискаHTML = 
				НСтр("ru='<li><b>Уточните область поиска.</b><br>
                    |Попробуйте выбрать больше областей поиска или все разделы.</li>'
                    |;uk='<li><b>Уточніть область пошуку.</b><br>
                    |Спробуйте вибрати більше областей або всі розділи.</li>'");
		КонецЕсли;
		
		РекомендацияТекстЗапросаHTML =
			НСтр("ru='<li><b>Упростите запрос, исключив из него какое-либо слово.</b></li>';uk='<li><b>Спростіть запит, виключивши з нього яке-небудь слово.</b></li>'");
		
	ИначеЕсли КодОшибки = "СлишкомМногоРезультатов" Тогда
		
		Если Не ИскатьВРазделах Или Не УказаныОбластиПоиска Тогда 
			
			РекомендацияОбластиПоискаHTML = 
			НСтр("ru='<li><b>Уточните область поиска.</b><br>
                |Попробуйте выбрать область поиска, задав точный раздел или список.</li>'
                |;uk='<li><b>Уточніть область пошуку.</b><br>
                |Спробуйте вибрати область пошуку, задавши точний розділ або список.</li>'");
		КонецЕсли;
		
	КонецЕсли;
	
	РекомендацииHTML = СтрЗаменить(РекомендацииHTML, "%РекомендацияОбластиПоиска%", РекомендацияОбластиПоискаHTML);
	РекомендацииHTML = СтрЗаменить(РекомендацииHTML, "%РекомендацияТекстЗапроса%", РекомендацияТекстЗапросаHTML);
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСтраницы, ОписаниеОшибки, РекомендацииHTML);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПредставлениеСостоянияПоиска(КонтейнерСостояний)
	
	СостояниеПоиска = КонтейнерСостояний.СостояниеПоиска;
	
	Если СостояниеПоиска = "ПоискРазрешен" Тогда 
		Представление = "";
	ИначеЕсли СостояниеПоиска = "ВыполняетсяОбновлениеИндекса"
		Или СостояниеПоиска = "ВыполняетсяСлияниеИндекса"
		Или СостояниеПоиска = "ТребуетсяОбновлениеИндекса" Тогда 
		
		Представление = НСтр("ru='Результаты поиска могут быть неточными, повторите поиск позднее.';uk='Результати пошуку можуть бути неточними, повторіть пошук пізніше.'");
	ИначеЕсли СостояниеПоиска = "ОшибкаНастройкиПоиска" Тогда 
		
		// Для не администратора
		Представление = НСтр("ru='Полнотекстовый поиск не настроен, обратитесь к администратору.';uk='Повнотекстовий пошук не налаштований, зверніться до адміністратора.'");
		
	ИначеЕсли СостояниеПоиска = "ПоискЗапрещен" Тогда 
		Представление = НСтр("ru='Полнотекстовый поиск отключен.';uk='Повнотекстовий пошук відключений.'");
	КонецЕсли;
	
	Возврат Представление;
	
КонецФункции

&НаСервере
Процедура ОбновитьВидимостьСостояниеПоиска(КонтейнерСостояний)
	
	СостояниеПоиска = КонтейнерСостояний.СостояниеПоиска;
	Элементы.СостояниеПоиска.Видимость = (СостояниеПоиска <> "ПоискРазрешен");
	
КонецПроцедуры

#КонецОбласти

#Область БизнесЛогика

&НаСервереБезКонтекста
Процедура ЗагрузитьНастройкиИИсториюПоиска(НастройкиПоиска)
	
	ИсторияПоиска = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ПолнотекстовыйПоискСтрокиПолнотекстовогоПоиска", "");
	СохраненныеНастройкиПоиска = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиПолнотекстовогоПоиска", "");
	
	ИскатьВРазделах = Неопределено;
	ОбластиПоиска   = Неопределено;
	
	Если ТипЗнч(СохраненныеНастройкиПоиска) = Тип("Структура") Тогда
		СохраненныеНастройкиПоиска.Свойство("ИскатьВРазделах", ИскатьВРазделах);
		СохраненныеНастройкиПоиска.Свойство("ОбластиПоиска",   ОбластиПоиска);
	КонецЕсли;
	
	НастройкиПоиска.ИскатьВРазделах = ?(ИскатьВРазделах = Неопределено, Ложь, ИскатьВРазделах);
	НастройкиПоиска.ОбластиПоиска   = ?(ОбластиПоиска = Неопределено, Новый СписокЗначений, ОбластиПоиска);
	НастройкиПоиска.ИсторияПоиска   = ?(ИсторияПоиска = Неопределено, Новый Массив, ИсторияПоиска);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СохранитьСтрокуПоискаВИстории(СтрокаПоиска, ИсторияПоиска)
	
	СохраненнаяСтрока = ИсторияПоиска.Найти(СтрокаПоиска);
	
	Если СохраненнаяСтрока <> Неопределено Тогда
		ИсторияПоиска.Удалить(СохраненнаяСтрока);
	КонецЕсли;
	
	ИсторияПоиска.Вставить(0, СтрокаПоиска);
	
	КоличествоСтрок = ИсторияПоиска.Количество();
	
	Если КоличествоСтрок > 20 Тогда
		ИсторияПоиска.Удалить(КоличествоСтрок - 1);
	КонецЕсли;
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
		"ПолнотекстовыйПоискСтрокиПолнотекстовогоПоиска",
		"",
		ИсторияПоиска);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СохранитьНастройкиПоиска(ИскатьВРазделах, ОбластиПоиска)
	
	Настройки = Новый Структура;
	Настройки.Вставить("ИскатьВРазделах", ИскатьВРазделах);
	Настройки.Вставить("ОбластиПоиска",   ОбластиПоиска);
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("НастройкиПолнотекстовогоПоиска", "", Настройки);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
