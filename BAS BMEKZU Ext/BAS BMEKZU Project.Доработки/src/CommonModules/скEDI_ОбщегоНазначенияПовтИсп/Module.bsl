//added by Al
Функция СМС_ОпределитьДокументНакладнаяНаСервере(ВидЭлектронногоДокумента) Экспорт
	
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	                      |	МАКСИМУМ(ВложенныйЗапрос.ЭтоНеПТУ_РТУ
	                      |			ИЛИ ЕСТЬNULL(ВложенныйЗапрос1.ЭтоПТУ_РТУ, ЛОЖЬ)) КАК ЭтоПТУ_РТУ
	                      |ИЗ
	                      |	(ВЫБРАТЬ
	                      |		ЛОЖЬ КАК ЭтоНеПТУ_РТУ) КАК ВложенныйЗапрос
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ РАЗЛИЧНЫЕ
	                      |			скEDI_СоответствиеВидовЭлектронныхИУчетныхДокументов.ВидДокумента1С = ЗНАЧЕНИЕ(Перечисление.скEDI_ВидыДокументов1С.РеализацияТоваровУслуг)
	                      |				ИЛИ скEDI_СоответствиеВидовЭлектронныхИУчетныхДокументов.ВидДокумента1С = ЗНАЧЕНИЕ(Перечисление.скEDI_ВидыДокументов1С.ПоступлениеТоваровУслуг)
	                      |				ИЛИ скEDI_СоответствиеВидовЭлектронныхИУчетныхДокументов.ВидДокумента1С = ЗНАЧЕНИЕ(Перечисление.скEDI_ВидыДокументов1С.ПриходнаяНакладная)
	                      |				ИЛИ скEDI_СоответствиеВидовЭлектронныхИУчетныхДокументов.ВидДокумента1С = ЗНАЧЕНИЕ(Перечисление.скEDI_ВидыДокументов1С.РасходнаяНакладная) КАК ЭтоПТУ_РТУ
	                      |		ИЗ
	                      |			РегистрСведений.скEDI_СоответствиеВидовЭлектронныхИУчетныхДокументов КАК скEDI_СоответствиеВидовЭлектронныхИУчетныхДокументов
	                      |		ГДЕ
	                      |			скEDI_СоответствиеВидовЭлектронныхИУчетныхДокументов.ВидЭлектронногоДокумента = &ВидЭлектронногоДокумента) КАК ВложенныйЗапрос1
	                      |		ПО (1 = 1)");
		
	Запрос.УстановитьПараметр("ВидЭлектронногоДокумента", ВидЭлектронногоДокумента);
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	Возврат Выборка.ЭтоПТУ_РТУ;	
	
КонецФункции
//added by Al