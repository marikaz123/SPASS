-----------------------------------------------------------------------------
    *** SPASS v1.3 ***
                                                           (c)1995 'marikaz'
-----------------------------------------------------------------------------

Program powstal jako odpowiedz na post z pewnej grupy usenet'owej, w ktorym
uzytkownik pytal o "Prosty program do zahaslowania dostepu do komputera".
Program mial byc maly, uruchamiac sie oczywiscie przy starcie komputera
i dzialac na 'mlodszego brata'.
Zaproponowalem wlasne rozwiazanie.


DZIALANIE
---------

        Pierwsze uruchomienie

Przede wszystkim pierwsze uruchomienie musi wykonac osoba chcaca ustawic
haslo do komputera - 'administrator'. Po uruchomieniu program probuje
otworzyc plik 'spass.dat' w ktorym przechowywane jest "zaszyfrowane" haslo.
Tego pliku jeszcze nie ma, dlatego program uruchamia tryb ustawienia hasla
'administratora':

 PASSWORD:_

Nastepnie koduje wprowadzone haslo, zapisuje na dysk w pliku spass.dat
i wychodzi do DOS. W tym momencie nalezy zmodyfikowac autoexec.bat, aby
uruchamial program przy starcie komputera.

      Uwaga!
      W programie nie zaimplementowano weryfikacji hasla
      'administratora', dlatego program na tym etapie
      WYSWIETLA wprowadzone znaki.
      Znaki te sa natychmiast kasowane po zatwierdzeniu
      klawiszem Enter.

Majac powyzsze na uwadze 'administrator' powinien zadbac o to, aby 'mlodszy
brat' nie sterczal za plecami podczas przeprowadzania tej procedury :-)

Podczas wpisywania hasla 'administratora' nie ma mozliwosci skasowania juz
raz wprowadzonego znaku. Dlatego w przypadku pomylki nalezy zatwierdzic haslo
z bledem i po wyjsciu programu do DOS skasowac wygenerowany plik spass.dat,
a procedure powtorzyc.
Jak nietrudno sie domyslic zmiana hasla odbywa sie w ten sam sposob.


        Kolejne uruchomienia

Przy kolejnych uruchomieniach (juz z autoexec'a) program sprawdza czy plik
spass.dat jest dostepny. Poniewaz jest to kolejne uruchomienie i
'admninistrator' utworzyl ten plik w pierwszym kroku, program go otwiera,
zawartosc przepisuje do bufora, a sam SPASS przechodzi w tryb weryfikacji
hasla. Wyswietli sie komunikat:

PASSWORD:_

      Uwaga!
      Program na tym etapie NIE WYSWIETLA wprowadzanych
      znakow oraz NIE REAGUJE na Ctrl+c.

Tym razem musi to byc haslo zgodne z tym wprowadzonym przy pierwszym
uruchomieniu. Wprowadzone haslo zostaje porownane ze zdekodowanym haslem
z bufora.
Jezeli haslo jest prawidlowe to program konczy dzialanie i wychodzi do DOS,
czyli de facto zezwala na dalsze korzystanie z komputera.
Jesli nie, wykonuje przewidziany na taka okolicznosc kod.


        Bledne haslo

Po wpisaniu nieprawidlowego hasla program uniemozliwia dalsze korzystanie
z komputera.


KOMPATYBILNOSC
--------------

Program zostal napisany na maszyne fizyczna i na takiej zostal sprawdzony
i poprawnie dzialal (ver. 1.1)

- MS-DOS v5.0+

Na VirtualBox zostal przetestowany po wprowadzeniu poprawek (ver. 1.3)

- MS-DOS v5.0+
- FreeDOS v1.3
- Caldera DR-DOS v7.03

Emulator

- DOSBox v0.74-3  - skompilowano aktualna wersje.
