
&НаКлиенте
Процедура ПараметрНастройкиПриИзменении(Элемент)
	УстановитьТипЗначения(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	УстановитьТипЗначения(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	УстановитьТипЗначения(ЭтаФорма);
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьТипЗначения(Форма)

	ТипЗначения = Неопределено;
	
	Если Форма.Запись.ПараметрНастройки = ПредопределенноеЗначение("Перечисление.ПараметрыЗаконодательныхИзменений.ДатаНачалаИспользованияФормыНН13") Тогда
		ТипЗначения = Новый ОписаниеТипов("Дата");
	КонецЕсли;
	
	Если ТипЗначения <> Неопределено Тогда
		
		Форма.Элементы.ЗначениеПараметра.ВыбиратьТип = Ложь;
		ПриведенноеЗначение = ТипЗначения.ПривестиЗначение(Форма.Запись.ЗначениеПараметра);
		Если Форма.Запись.ЗначениеПараметра <> ПриведенноеЗначение Тогда
			Форма.Модифицированность = Истина;
			Форма.Запись.ЗначениеПараметра = ПриведенноеЗначение;
		КонецЕсли;
		
	Иначе
		Форма.Элементы.ЗначениеПараметра.ВыбиратьТип = Истина;		
	КонецЕсли;

КонецПроцедуры
