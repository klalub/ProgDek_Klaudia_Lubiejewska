:- dynamic(pasa�er/5).
:- dynamic(lot/5).
:- dynamic(rezerwacja/4).
:- dynamic(odprawa/3).
:- dynamic(baga�/4).
:- dynamic(kontrola_bezpiecze�stwa/3).

% Baza danych pasa�er�w
% pasa�er(ID, Imi�, Nazwisko, Narodowo��, Numer_Paszportu).
pasa�er(1, 'Jan', 'Kowalski', 'Polska', 'ABC123456').
pasa�er(2, 'Anna', 'Nowak', 'Polska', 'DEF789012').
pasa�er(3, 'John', 'Doe', 'USA', 'XYZ345678').
pasa�er(4, 'Marta', 'Lewandowska', 'Polska', 'GHI456789').

% Baza danych lot�w
% lot(Numer_Lotu, Data, Miasto_Odlotu, Miasto_Przylotu, Status).
lot('LO123', '2024-05-26', 'Warszawa', 'Londyn', 'Na czas').
lot('LO124', '2024-05-27', 'Warszawa', 'Pary�', 'Na czas').

% Baza danych rezerwacji
% rezerwacja(ID_Pasa�era, Numer_Lotu, Klasa, Miejsce).
rezerwacja(1, 'LO123', 'Ekonomiczna', '12A').
rezerwacja(2, 'LO123', 'Ekonomiczna', '12B').
rezerwacja(3, 'LO124', 'Biznes', '2A').
rezerwacja(4, 'LO123', 'Ekonomiczna', '15C').

% Baza danych odpraw
% odprawa(ID_Pasa�era, Numer_Lotu, Status).
odprawa(1, 'LO123', 'Odprawiony').
odprawa(2, 'LO123', 'Odprawiony').

% Baza danych baga�u
% baga�(ID_Pasa�era, Numer_Lotu, Numer_Bagazu, Status).
baga�(1, 'LO123', 'BG001', 'Nadany').
baga�(2, 'LO123', 'BG002', 'Nadany').

% Dodawanie nowego pasa�era
dodaj_pasa�era(ID, Imi�, Nazwisko, Narodowo��, Numer_Paszportu) :-
    \+ pasa�er(ID, _, _, _, _),
    assert(pasa�er(ID, Imi�, Nazwisko, Narodowo��, Numer_Paszportu)),
    format('Dodano nowego pasa�era: ~w~n',[ID]).

% Dodawanie nowego lotu
dodaj_lot(Numer_Lotu, Data, Miasto_Odlotu, Miasto_Przylotu, Status):-
    \+ lot(Numer_Lotu, _, _, _, _),
    assert(lot(Numer_Lotu, Data, Miasto_Odlotu, Miasto_Przylotu, Status)),
    format('Dodano nowy lot: ~w~n',[Numer_Lotu]).

% Dodawanie nowej rezerwacji
dodaj_rezerwacje(ID_Pasa�era, Numer_Lotu, Klasa, Miejsce) :-
    pasa�er(ID_Pasa�era, _, _, _, _),
    \+ rezerwacja(ID_Pasa�era, Numer_Lotu, _, _),
    assert(rezerwacja(ID_Pasa�era, Numer_Lotu, Klasa, Miejsce)),
    format('Dodano now� rezerwacj�: ~w, ~w.~n',[ID_Pasa�era,Numer_Lotu]).

% Odprawa pasa�era
odprawa_pasa�era(ID_Pasa�era, Numer_Lotu) :-
    rezerwacja(ID_Pasa�era, Numer_Lotu, _, _),
    \+ odprawa(ID_Pasa�era, Numer_Lotu, _),
    assert(odprawa(ID_Pasa�era, Numer_Lotu, 'Odprawiony')).

% Dodawanie baga�u pasa�era
dodaj_baga�(ID_Pasa�era, Numer_Lotu, Numer_Bagazu) :-
    odprawa(ID_Pasa�era, Numer_Lotu, 'Odprawiony'),
    \+ baga�(ID_Pasa�era, Numer_Lotu, Numer_Bagazu, _),
    assert(baga�(ID_Pasa�era, Numer_Lotu, Numer_Bagazu, 'Nadany')),
    format('Dodano nowy baga�: ~w~n',[Numer_Bagazu]).

% Aktualizacja statusu baga�u
aktualizacja_statusu_baga�u(Numer_Bagazu, NowyStatus) :-
    retract(baga�(ID_Pasa�era, Numer_Lotu, Numer_Bagazu, _)),
    assert(baga�(ID_Pasa�era, Numer_Lotu, Numer_Bagazu, NowyStatus)).

% Wyszukiwanie rezerwacji dla pasa�era
znajd�_rezerwacje(ID_Pasa�era, Rezerwacje) :-
    findall([Numer_Lotu, Klasa, Miejsce], rezerwacja(ID_Pasa�era, Numer_Lotu, Klasa, Miejsce), Rezerwacje).

% Przypisywanie miejsc pasa�erom
przypisz_miejsce(ID_Pasa�era, Numer_Lotu, Miejsce) :-
    retract(rezerwacja(ID_Pasa�era, Numer_Lotu, Klasa, _)),
    assert(rezerwacja(ID_Pasa�era, Numer_Lotu, Klasa, Miejsce)).

% Aktualizacja statusu lotu
aktualizacja_statusu_lotu(Numer_Lotu, NowyStatus) :-
    retract(lot(Numer_Lotu, Data, Miasto_Odlotu, Miasto_Przylotu, _)),
    assert(lot(Numer_Lotu, Data, Miasto_Odlotu, Miasto_Przylotu, NowyStatus)).

% Generowanie listy pasa�er�w na dany lot
lista_pasa�er�w(Numer_Lotu, ListaPasa�er�w) :-
    findall([ID_Pasa�era, Imi�, Nazwisko],
        (rezerwacja(ID_Pasa�era, Numer_Lotu, _, _),
        pasa�er(ID_Pasa�era, Imi�, Nazwisko, _, _)),
        ListaPasa�er�w).

% Generowanie listy wszystkich lot�w
lista_lot�w(ListaLot�w) :-
    findall([Numer_Lotu, Data, Miasto_Odlotu, Miasto_Przylotu, Status],
        lot(Numer_Lotu, Data, Miasto_Odlotu, Miasto_Przylotu, Status),
        ListaLot�w).


% Wysy�anie powiadomie� pasa�erom
wy�lij_powiadomienie(ID_Pasa�era, Wiadomo��) :-
    pasa�er(ID_Pasa�era, Imi�, Nazwisko, _, _),
    format('Wysy�anie powiadomienia do ~w ~w: ~w~n', [Imi�, Nazwisko, Wiadomo��]).

% Wysy�anie powiadomie� o zmianie statusu lotu
powiadom_o_zmianie_statusu_lotu(Numer_Lotu, NowyStatus) :-
    aktualizacja_statusu_lotu(Numer_Lotu, NowyStatus),
    findall(ID_Pasa�era, rezerwacja(ID_Pasa�era, Numer_Lotu, _, _), Pasa�erowie),
    maplist(wy�lij_powiadomienie_o_zmianie_statusu_lotu(Numer_Lotu, NowyStatus), Pasa�erowie).

wy�lij_powiadomienie_o_zmianie_statusu_lotu(Numer_Lotu, NowyStatus, ID_Pasa�era) :-
    format(atom(Wiadomo��), 'Lot ~w ma nowy status: ~w', [Numer_Lotu, NowyStatus]),
    wy�lij_powiadomienie(ID_Pasa�era, Wiadomo��).

% Kontrola bezpiecze�stwa
% kontrola_bezpiecze�stwa(ID_Pasa�era, Numer_Lotu, Status).
kontrola_bezpiecze�stwa(1, 'LO123', 'Przeszed�').
kontrola_bezpiecze�stwa(2, 'LO123', 'Przeszed�').

wykonaj_kontrole_bezpiecze�stwa(ID_Pasa�era, Numer_Lotu) :-
    odprawa(ID_Pasa�era,Numer_Lotu,'Odprawiony'),
    \+ kontrola_bezpiecze�stwa(ID_Pasa�era,Numer_Lotu,_),
    assert(kontrola_bezpiecze�stwa(ID_Pasa�era, Numer_Lotu, 'Przeszed�')).

% Przyk�adowe zapytania
% ?- dodaj_pasa�era(5, 'Piotr', 'Zieli�ski', 'Polska', 'JKL123456').
% ?- dodaj_rezerwacje(5, 'LO123', 'Ekonomiczna', '16D').
% ?- znajd�_rezerwacje(1, Rezerwacje).
% ?- przypisz_miejsce(1, 'LO123', '10D').
% ?- odprawa_pasa�era(5, 'LO123').
% ?- dodaj_baga�(5, 'LO123', 'BG003').
% ?- aktualizacja_statusu_baga�u('BG003', 'Za�adowany').
% ?- wykonaj_kontrole_bezpiecze�stwa(5, 'LO123').
% ?- aktualizacja_statusu_lotu('LO123', 'Op�niony').
% ?- lista_pasa�er�w('LO123', ListaPasa�er�w).
% ?- powiadom_o_zmianie_statusu_lotu('LO123', 'Op�niony').
