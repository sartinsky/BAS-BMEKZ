
&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	Если ЗначениеЗаполнено(Организация) Тогда
		СохранитьГруппыПодписиСервере();
		ЗаполнитьГруппыПодписиСервере();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьГруппыПодписиСервере()
	ГруппыПодписи.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	скEDI_Подписи.Ссылка,
	               |	ВЫБОР
	               |		КОГДА скEDI_ГруппыПодписейРегистр.Подпись ЕСТЬ NULL
	               |			ТОГДА ЛОЖЬ
	               |		ИНАЧЕ ИСТИНА
	               |	КОНЕЦ КАК ВходитВГруппу
	               |ИЗ
	               |	Справочник.скEDI_Подписи КАК скEDI_Подписи
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.скEDI_ГруппыПодписей КАК скEDI_ГруппыПодписейРегистр
	               |		ПО скEDI_Подписи.Ссылка = скEDI_ГруппыПодписейРегистр.Подпись
	               |			И (скEDI_ГруппыПодписейРегистр.ГруппаПодписи = &ГруппаПодписи)
	               |ГДЕ
	               |	скEDI_Подписи.Владелец = &Организация
	               |	И скEDI_Подписи.ИспользованиеКлюча = ЗНАЧЕНИЕ(Перечисление.скEDI_ИспользованиеКлючей.Подписание)
	               |	И (скEDI_ГруппыПодписейРегистр.ГруппаПодписи ЕСТЬ НЕ NULL 
	               |			ИЛИ НЕ скEDI_Подписи.Роль В (&РолиПодписейИсключение))
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	скEDI_Подписи.Наименование";
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ГруппаПодписи", Объект.Ссылка);
	
	РолиПодписей = Новый СписокЗначений;
	Если Объект.Ссылка = ПредопределенноеЗначение("Справочник.скEDI_ГруппыПодписей.Руководитель") Тогда
		РолиПодписей.Добавить(ПредопределенноеЗначение("Перечисление.скEDI_РолиПодписей.ПечатьОрганизации"));
		РолиПодписей.Добавить(ПредопределенноеЗначение("Перечисление.скEDI_РолиПодписей.ПодписьБухгалтера"));
		РолиПодписей.Добавить(ПредопределенноеЗначение("Перечисление.скEDI_РолиПодписей.ПодписьОтветственногоЛица"));
		РолиПодписей.Добавить(ПредопределенноеЗначение("Перечисление.скEDI_РолиПодписей.ПодписьФизическогоЛица"));
	ИначеЕсли Объект.Ссылка = ПредопределенноеЗначение("Справочник.скEDI_ГруппыПодписей.Бухгалтер") Тогда
		РолиПодписей.Добавить(ПредопределенноеЗначение("Перечисление.скEDI_РолиПодписей.ПечатьОрганизации"));
		РолиПодписей.Добавить(ПредопределенноеЗначение("Перечисление.скEDI_РолиПодписей.ПодписьДиректора"));
		РолиПодписей.Добавить(ПредопределенноеЗначение("Перечисление.скEDI_РолиПодписей.ПодписьОтветственногоЛица"));
		РолиПодписей.Добавить(ПредопределенноеЗначение("Перечисление.скEDI_РолиПодписей.ПодписьФизическогоЛица"));
	ИначеЕсли Объект.Ссылка = ПредопределенноеЗначение("Справочник.скEDI_ГруппыПодписей.Печать") Тогда
		РолиПодписей.Добавить(ПредопределенноеЗначение("Перечисление.скEDI_РолиПодписей.ПодписьБухгалтера"));
		РолиПодписей.Добавить(ПредопределенноеЗначение("Перечисление.скEDI_РолиПодписей.ПодписьДиректора"));
		РолиПодписей.Добавить(ПредопределенноеЗначение("Перечисление.скEDI_РолиПодписей.ПодписьОтветственногоЛица"));
		РолиПодписей.Добавить(ПредопределенноеЗначение("Перечисление.скEDI_РолиПодписей.ПодписьФизическогоЛица"));
	ИначеЕсли Объект.Ссылка = ПредопределенноеЗначение("Справочник.скEDI_ГруппыПодписей.ОтветственноеЛицо") Тогда
		РолиПодписей.Добавить(ПредопределенноеЗначение("Перечисление.скEDI_РолиПодписей.ПечатьОрганизации"));
	ИначеЕсли Объект.Ссылка = ПредопределенноеЗначение("Справочник.скEDI_ГруппыПодписей.ДопДокументыДФС") Тогда
		РолиПодписей.Добавить(ПредопределенноеЗначение("Перечисление.скEDI_РолиПодписей.ПодписьФизическогоЛица"));
	Иначе
	КонецЕсли;
	Запрос.УстановитьПараметр("РолиПодписейИсключение", РолиПодписей);
	
	ВыборкаРезультатаЗапроса = Запрос.Выполнить().Выбрать();
	Пока ВыборкаРезультатаЗапроса.Следующий() Цикл
		НоваяСтрока = ГруппыПодписи.Добавить();
		НоваяСтрока.Подпись = ВыборкаРезультатаЗапроса.Ссылка;
		НоваяСтрока.ВходитВГруппу = ВыборкаРезультатаЗапроса.ВходитВГруппу;
		НоваяСтрока.ВходитВГруппуКеш = ВыборкаРезультатаЗапроса.ВходитВГруппу;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура СохранитьГруппыПодписиСервере()
	Для Каждого ГруппаПодписи Из ГруппыПодписи Цикл
		Если ГруппаПодписи.ВходитВГруппуКеш <> ГруппаПодписи.ВходитВГруппу Тогда
			ГруппыПодписейМенеджерЗаписи = РегистрыСведений.скEDI_ГруппыПодписей.СоздатьМенеджерЗаписи();
			ГруппыПодписейМенеджерЗаписи.Подпись = ГруппаПодписи.Подпись;
			ГруппыПодписейМенеджерЗаписи.ГруппаПодписи = Объект.Ссылка;
			Если ГруппаПодписи.ВходитВГруппу Тогда
				ГруппыПодписейМенеджерЗаписи.Записать(Истина);
			Иначе
				ГруппыПодписейМенеджерЗаписи.Удалить();
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	лОрганизация = Неопределено;
	Если Параметры.Свойство("Организация", лОрганизация) Тогда
		Организация = лОрганизация;
	КонецЕсли;
	Если ЗначениеЗаполнено(Организация) Тогда
		ЗаполнитьГруппыПодписиСервере();
		Элементы.ГруппыПодписи.Видимость = Истина;
	Иначе
		Элементы.ГруппыПодписи.Видимость = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ГруппыПодписиПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры
