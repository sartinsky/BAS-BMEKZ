
Процедура ПередЗаписью(Отказ)
	ТолькоОтветственныйУжеУказан = Ложь;
	Для Каждого Подпись Из Подписи Цикл
		Если Подпись.ТолькоОтветственный Тогда
			Если ТолькоОтветственныйУжеУказан Тогда
				Сообщить(НСтр("ru = 'В списке Подписантов отметка ""Только ответственный (для исходящих документов)"" может быть только одна!'; uk = 'В списку Підписантів відмітка ""Тільки відповідальний (для вихідних документів)"" може бути тільки одна!'"));
				Отказ = Истина;
				Возврат;
			КонецЕсли;
			ТолькоОтветственныйУжеУказан = Истина;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	//Отказ = Не МонопольныйРежим();
КонецПроцедуры

