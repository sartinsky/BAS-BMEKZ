
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ЗарегистрироватьТарифицируемыеУслуги();
	
	ПоказатьПредупреждение(, НСтр("ru='Услуги отправлены в Менеджер сервиса';uk='Послуги відправлені в Менеджер сервісу'"));
	
КонецПроцедуры

&НаСервере
Процедура ЗарегистрироватьТарифицируемыеУслуги()
	
	ТарификацияСлужебный.ЗарегистрироватьТарифицируемыеУслуги_РегламентноеЗадание();
	
КонецПроцедуры
