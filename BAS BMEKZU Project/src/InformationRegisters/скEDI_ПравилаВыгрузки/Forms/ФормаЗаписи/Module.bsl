
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Элементы.ВидДокумента1С.РежимВыбораИзСписка = Истина;
	Элементы.ВидДокумента1С.СписокВыбора.ЗагрузитьЗначения(скEDI_НастройкиПодКонфигурацию.ПолучитьМассивИспользуемыхВКонфигурацииВидовДокументов1С());
КонецПроцедуры

&НаКлиенте
Процедура ВыборШаблонаДокумента(ДанныеВыбора, ДопПараметр) Экспорт
	Если ТипЗнч(ДанныеВыбора) = Тип("Структура") Тогда
		ТекЕДРПОУВладельца = "";
		Если ДанныеВыбора.Свойство("ЕДРПОУВладельца", ТекЕДРПОУВладельца) Тогда
			Запись.ЕДРПОУВладельцаШаблона = ТекЕДРПОУВладельца;
		КонецЕсли;
		ТекКодШаблона = "";
		Если ДанныеВыбора.Свойство("КодШаблона", ТекКодШаблона) Тогда
			Запись.ИмяШаблона = ТекКодШаблона;
		КонецЕсли;
		ТекВерсия = "";
		Если ДанныеВыбора.Свойство("Версия", ТекВерсия) Тогда
			Запись.ВерсияШаблона = ТекВерсия;
		КонецЕсли;
		ТекНаименование = "";
		Если ДанныеВыбора.Свойство("Наименование", ТекНаименование) Тогда
			Запись.Наименование = ТекНаименование;
		КонецЕсли;
		
		Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьШаблонСПлатформыПТАХ(Команда)
	ПараметрыФормы = Новый Структура("ТекЕДРПОУВладельца, ТекИмяШаблона, ТекВерсияШаблона, ВидЭлектронногоДокумента, ДляСозданияЭлектронныхДокументов", Запись.ЕДРПОУВладельцаШаблона, Запись.ИмяШаблона, Запись.ВерсияШаблона, Запись.ВидЭлектронногоДокумента, Истина);
	Если скEDI_ОбщегоНазначения.ЭтоПлатформа82() Тогда
		ВыбранныеПоляОтбора = ПолучитьФорму("ОбщаяФорма.скEDI_ФормаВыбораШаблонаДокумента", ПараметрыФормы).ОткрытьМодально();
		ВыборШаблонаДокумента(ВыбранныеПоляОтбора, Неопределено);
	Иначе
		скEDI_ОткрытиеФормБезМодальности.ОткрытьФормуВыбораШаблонаДокумента(ПараметрыФормы, ЭтаФорма);
	КонецЕсли;
КонецПроцедуры
