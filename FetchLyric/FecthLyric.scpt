FasdUAS 1.101.10   ��   ��    k             l     ��  ��      FetchLyric     � 	 	    F e t c h L y r i c   
  
 l     ��  ��    B < DESCRIPTION: ?iTunes????????????????????????????????Growl??     �   x   D E S C R I P T I O N :  �� i T u n e sQ�_SRM���	N-v�f�v��R�N�}^vO�[XkL�����kL��]�[XW(\��_�ue�e/c G r o w l�w�      l     ��  ��    * $ AUTHOR: JinnLynn http:://jeeker.net     �   H   A U T H O R :   J i n n L y n n   h t t p : : / / j e e k e r . n e t      l     ��  ��      LAST UPDATED: 2012-05-04     �   2   L A S T   U P D A T E D :   2 0 1 2 - 0 5 - 0 4      l     ��  ��    < 6 INTRO PAGE: http://jeeker.net/fetch-lyric-for-itunes/     �   l   I N T R O   P A G E :   h t t p : / / j e e k e r . n e t / f e t c h - l y r i c - f o r - i t u n e s /      l     ��   !��     a [ REF: Martian http://blog.4321.la/articles/2012/01/27/use-applescript-to-set-itunes-lyrics/    ! � " " �   R E F :   M a r t i a n   h t t p : / / b l o g . 4 3 2 1 . l a / a r t i c l e s / 2 0 1 2 / 0 1 / 2 7 / u s e - a p p l e s c r i p t - t o - s e t - i t u n e s - l y r i c s /   # $ # j     �� %�� 0 
scriptname 
scriptName % m      & & � ' '  F e t c h L y r i c $  ( ) ( j    �� *�� 0 baseurl baseURL * m     + + � , , 4 h t t p : / / l y r i c s . s i n a a p p . c o m / )  - . - j    �� /��  0 isgrowlrunning isGrowlRunning / m    ��
�� boovfals .  0 1 0 j   	 �� 2�� 0 
statusdesc 
statusDesc 2 J   	  3 3  4 5 4 m   	 
 6 6 � 7 7 kL��]�[XW(�e�� Q���S�0 5  8 9 8 m   
  : : � ; ; kL�̓�S�bR�0 9  < = < m     > > � ? ? kL�̓�S�Y1�%0 =  @�� @ m     A A � B B g*�	b�kLf�0��   1  C D C j    �� E�� (0 status_lyric_exist STATUS_LYRIC_EXIST E m    ����  D  F G F j    �� H�� ,0 status_lyric_success STATUS_LYRIC_SUCCESS H m    ����  G  I J I j    �� K�� &0 status_lyric_fail STATUS_LYRIC_FAIL K m    ����  J  L M L j    �� N�� 20 status_lyric_unselected STATUS_LYRIC_UNSELECTED N m    ����  M  O P O l     ��������  ��  ��   P  Q R Q l     S���� S O      T U T r     V W V ?     X Y X l    Z���� Z I   �� [��
�� .corecnte****       **** [ l    \���� \ 6    ] ^ ] 2    ��
�� 
prcs ^ =    _ ` _ 1   	 ��
�� 
bnid ` m     a a � b b 0 c o m . G r o w l . G r o w l H e l p e r A p p��  ��  ��  ��  ��   Y m    ����   W o      ����  0 isgrowlrunning isGrowlRunning U m      c c�                                                                                  sevs  alis    �  
MacOSXLion                 ����H+     uSystem Events.app                                                �(��Z        ����  	                CoreServices    ��?H      �3�       u   h   g  ;MacOSXLion:System: Library: CoreServices: System Events.app   $  S y s t e m   E v e n t s . a p p   
 M a c O S X L i o n  -System/Library/CoreServices/System Events.app   / ��  ��  ��   R  d e d l     ��������  ��  ��   e  f g f h    &�� h�� 	0 growl   h i      i j i I      �� k���� 0 growlnotify growlNotify k  l m l o      ���� 
0 artist   m  n o n o      ���� 	0 title   o  p�� p o      ���� 
0 status  ��  ��   j k     � q q  r s r Z     t u���� t =      v w v o     ����  0 isgrowlrunning isGrowlRunning w m    ��
�� boovfals u L   
 ����  ��  ��   s  x�� x O    � y z y k    � { {  | } | Z   & ~ ���� ~ =     � � � o    ���� 	0 title   � m     � � � � �    r    " � � � m      � � � � �  u n k n o w n � o      ���� 	0 title  ��  ��   }  � � � r   ' * � � � o   ' (���� 	0 title   � o      ���� 0 	the_title   �  � � � Z  + < � ����� � >  + . � � � o   + ,���� 
0 artist   � m   , - � � � � �   � r   1 8 � � � b   1 6 � � � b   1 4 � � � o   1 2���� 
0 artist   � m   2 3 � � � � �    -   � o   4 5���� 0 	the_title   � o      ���� 0 	the_title  ��  ��   �  � � � r   = G � � � n   = E � � � 4   B E�� �
�� 
cobj � o   C D���� 
0 status   � o   = B���� 0 
statusdesc 
statusDesc � o      ���� 0 the_desc   �  � � � r   H Q � � � J   H O � �  ��� � o   H M���� 0 
scriptname 
scriptName��   � l      ����� � o      ���� ,0 allnotificationslist allNotificationsList��  ��   �  � � � r   R [ � � � J   R Y � �  ��� � o   R W���� 0 
scriptname 
scriptName��   � l      ����� � o      ���� 40 enablednotificationslist enabledNotificationsList��  ��   �  � � � I  \ m���� �
�� .registernull��� ��� null��   � �� � �
�� 
appl � l 	 ^ c ����� � o   ^ c���� 0 
scriptname 
scriptName��  ��   � �� � �
�� 
anot � l 
 d e ����� � o   d e���� ,0 allnotificationslist allNotificationsList��  ��   � �� � �
�� 
dnot � l 
 f g ����� � o   f g���� 40 enablednotificationslist enabledNotificationsList��  ��   � �� ���
�� 
iapp � m   h i � � � � �  i T u n e s��   �  � � � I  n ����� �
�� .notifygrnull��� ��� null��   � �� � �
�� 
name � l 	 p u ����� � o   p u���� 0 
scriptname 
scriptName��  ��   � �� � �
�� 
titl � l 	 x y ����� � o   x y���� 0 	the_title  ��  ��   � �� � �
�� 
desc � l 	 | } ����� � o   | }���� 0 the_desc  ��  ��   � �� ���
�� 
appl � o   ~ ����� 0 
scriptname 
scriptName��   �  ��� � l  � ��� � ���   �   ??????????Growl????    � � � � (  \��Ou(kLf�\�bO\N: G r o w lV�hQ����   z 5    �� ���
�� 
capp � m     � � � � � 0 c o m . G r o w l . G r o w l H e l p e r A p p
�� kfrmID  ��   g  � � � l     ��������  ��  ��   �  ��� � l  b ����� � O   b � � � k   "a � �  � � � Z   " G � ����� � =  " ( � � � 1   " %��
�� 
sele � J   % '����   � k   + C � �  � � � O  + @ � � � I   3 ?�� ����� 0 growlnotify growlNotify �  � � � m   4 5 � � � � �   �  � � � m   5 6 � � � � �   �  ��� � o   6 ;�� 20 status_lyric_unselected STATUS_LYRIC_UNSELECTED��  ��   � o   + 0�~�~ 	0 growl   �  ��} � L   A C�|�|  �}  ��  ��   �  � � � r   H S � � � I  H Q�{ ��z
�{ .corecnte****       **** � l  H M ��y�x � n   H M � � � m   K M�w
�w 
cobj � 1   H K�v
�v 
sele�y  �x  �z   � o      �u�u 0 k   �  � � � r   T W � � � m   T U�t�t  � o      �s�s 0 i   �  � � � T   X' � � k   ]"    r   ] e l  ] c�r�q n   ] c 4   ` c�p
�p 
cobj o   a b�o�o 0 i   1   ] `�n
�n 
sele�r  �q   o      �m�m 0 thetrack theTrack 	
	 r   f n l  f j�l�k e   f j n   f j 1   g i�j
�j 
pArt o   f g�i�i 0 thetrack theTrack�l  �k   o      �h�h 0 this_artist  
  r   o y l  o u�g�f e   o u n   o u 1   p t�e
�e 
pnam o   o p�d�d 0 thetrack theTrack�g  �f   o      �c�c 0 
this_title    r   z � l  z ��b�a e   z � n   z �  1   { �`
�` 
pLyr  o   z {�_�_ 0 thetrack theTrack�b  �a   o      �^�^ 0 
this_lyric   !"! l  � ��]#$�]  # 8 2 set this_artwork to data of artwork 1 of theTrack   $ �%% d   s e t   t h i s _ a r t w o r k   t o   d a t a   o f   a r t w o r k   1   o f   t h e T r a c k" &'& l  � ��\�[�Z�\  �[  �Z  ' ()( r   � �*+* o   � ��Y�Y &0 status_lyric_fail STATUS_LYRIC_FAIL+ o      �X�X 0 fetch_status  ) ,-, l  � ��W�V�U�W  �V  �U  - ./. Z   � �01�T20 A   � �343 n   � �565 1   � ��S
�S 
leng6 o   � ��R�R 0 
this_lyric  4 m   � ��Q�Q 1 k   � �77 898 l  � ��P:;�P  :   ???????????????????   ; �<< (  S�g	_SkLf�N-g*[XW(kL��e�bM\�Ճ�S�kL��9 =>= r   � �?@? b   � �ABA b   � �CDC b   � �EFE m   � �GG �HH  t i t l e =F o   � ��O�O 0 
this_title  D m   � �II �JJ  & a r t i s t =B o   � ��N�N 0 this_artist  @ o      �M�M 0 requestdata requestData> KLK r   � �MNM I  � ��LO�K
�L .sysoexecTEXT���     TEXTO b   � �PQP b   � �RSR b   � �TUT m   � �VV �WW  c u r l   - d   'U o   � ��J�J 0 requestdata requestDataS m   � �XX �YY  '  Q o   � ��I�I 0 baseurl baseURL�K  N o      �H�H 0 
songlyrics 
songLyricsL Z�GZ Z   � �[\�F�E[ ?   � �]^] n   � �_`_ 1   � ��D
�D 
leng` o   � ��C�C 0 
songlyrics 
songLyrics^ m   � ��B�B \ k   � �aa bcb l  � ��Ade�A  d   ??????   e �ff   kL��bR���S�c ghg r   � �iji o   � ��@�@ 0 
songlyrics 
songLyricsj n      klk 1   � ��?
�? 
pLyrl o   � ��>�> 0 thetrack theTrackh m�=m r   � �non o   � ��<�< ,0 status_lyric_success STATUS_LYRIC_SUCCESSo o      �;�; 0 fetch_status  �=  �F  �E  �G  �T  2 r   � �pqp o   � ��:�: (0 status_lyric_exist STATUS_LYRIC_EXISTq o      �9�9 0 fetch_status  / rsr l  � ��8�7�6�8  �7  �6  s tut O  �vwv I  �5x�4�5 0 growlnotify growlNotifyx yzy o  �3�3 0 this_artist  z {|{ o  �2�2 0 
this_title  | }�1} o  �0�0 0 fetch_status  �1  �4  w o   � ��/�/ 	0 growl  u ~~ l �.�-�,�.  �-  �,   ��� r  ��� [  ��� o  �+�+ 0 i  � m  �*�* � o      �)�) 0 i  � ��(� Z "���'�&� ?  ��� o  �%�% 0 i  � o  �$�$ 0 k  �  S  �'  �&  �(   � ��� l ((�#���#  �   ??Growl?????????   � ��� "  Y�g� G r o w lg*�ЈLRf>y:[���hF� ��"� Z  (a���!� � =  (/��� o  (-��  0 isgrowlrunning isGrowlRunning� m  -.�
� boovfals� I 2]���
� .sysodlogaskr        TEXT� b  29��� o  25�
� 
ret � m  58�� ��� kL�̓�S�~�g_�� ���
� 
btns� J  <A�� ��� m  <?�� ��� xn[��  � ���
� 
dflt� m  DE�� � ���
� 
disp� m  HI�� � ���
� 
givu� m  LO�� � ���
� 
appr� o  RW�� 0 
scriptname 
scriptName�  �!  �   �"   � m    ���                                                                                  hook  alis    H  
MacOSXLion                 ����H+     �
iTunes.app                                                      `��t5�        ����  	                Applications    ��?H      �s�X       �  #MacOSXLion:Applications: iTunes.app    
 i T u n e s . a p p   
 M a c O S X L i o n  Applications/iTunes.app   / ��  ��  ��  ��       �� & +���������
�	���������  � ����� ������������������������������� 0 
scriptname 
scriptName� 0 baseurl baseURL�  0 isgrowlrunning isGrowlRunning� 0 
statusdesc 
statusDesc�  (0 status_lyric_exist STATUS_LYRIC_EXIST�� ,0 status_lyric_success STATUS_LYRIC_SUCCESS�� &0 status_lyric_fail STATUS_LYRIC_FAIL�� 20 status_lyric_unselected STATUS_LYRIC_UNSELECTED�� 	0 growl  
�� .aevtoappnull  �   � ****�� 0 k  �� 0 i  �� 0 thetrack theTrack�� 0 this_artist  �� 0 
this_title  �� 0 
this_lyric  �� 0 fetch_status  ��  ��  ��  
� boovtrue� ����� �   6 : > A� � � � � �� h  ��� 	0 growl  � ���� ��� & +���������������  � 
���������������������� 0 
scriptname 
scriptName�� 0 baseurl baseURL��  0 isgrowlrunning isGrowlRunning�� 0 
statusdesc 
statusDesc�� (0 status_lyric_exist STATUS_LYRIC_EXIST�� ,0 status_lyric_success STATUS_LYRIC_SUCCESS�� &0 status_lyric_fail STATUS_LYRIC_FAIL�� 20 status_lyric_unselected STATUS_LYRIC_UNSELECTED�� 	0 growl  
�� .aevtoappnull  �   � ****
�� boovtrue�� �� �� �� � �����������
�� .aevtoappnull  �   � ****� k    b��  Q��  �����  ��  ��  �  � ) c����� a����� � ���������������������������GI��VX������������������������
�� 
prcs�  
�� 
bnid
�� .corecnte****       ****
�� 
sele�� 0 growlnotify growlNotify
�� 
cobj�� 0 k  �� 0 i  �� 0 thetrack theTrack
�� 
pArt�� 0 this_artist  
�� 
pnam�� 0 
this_title  
�� 
pLyr�� 0 
this_lyric  �� 0 fetch_status  
�� 
leng�� 0 requestdata requestData
�� .sysoexecTEXT���     TEXT�� 0 
songlyrics 
songLyrics
�� 
ret 
�� 
btns
�� 
dflt
�� 
disp
�� 
givu�� 
�� 
appr�� 

�� .sysodlogaskr        TEXT��c� *�-�[�,\Z�81j jEc  UO�A*�,jv  b   *��b  m+ 
UOhY hO*�,�,j E�OkE�O �hZ*�,��/E�O��,EE` O�a ,EE` O�a ,EE` Ob  E` O_ a ,k Va _ %a %_ %E` Oa _ %a %b  %j E` O_ a ,k _ �a ,FOb  E` Y hY b  E` Ob   *_ _ _ m+ 
UO�kE�O�� Y h[OY�7Ob  f  0_ a %a  a !kva "ka #ka $a %a &b   a ' (Y hU� ���� 0 growlnotify growlNotify� �� j���������� 0 growlnotify growlNotify�� ����� �  �������� 
0 artist  �� 	0 title  �� 
0 status  ��  � ���������������� 
0 artist  �� 	0 title  �� 
0 status  �� 0 	the_title  �� 0 the_desc  �� ,0 allnotificationslist allNotificationsList�� 40 enablednotificationslist enabledNotificationsList� �� ��� � � � ����������� �������������
�� 
capp
�� kfrmID  
�� 
cobj
�� 
appl
�� 
anot
�� 
dnot
�� 
iapp�� 
�� .registernull��� ��� null
�� 
name
�� 
titl
�� 
desc
�� .notifygrnull��� ��� null�� �b  f  hY hO)���0 r��  �E�Y hO�E�O�� ��%�%E�Y hOb  �/E�Ob   kvE�Ob   kvE�O*�b   ����� O*�b   a �a ��b   � OPU�
 �	 � �� �������� �������� �������
�� 
cSrc�� J
�� kfrmID  
�� 
cUsP��!B
�� kfrmID  
�� 
cFlT��!R
�� kfrmID  � ��� h��Y�9� ��� R�l� ���r~�N�PZN���N*Q�[�  R+N�`NH��bNt SꉁO`N_N h7v���[� ba?aY)m�mw�Ґ���O`S� bw�SN RN[�f bv�_�N v�n)N`��g��]� g `O`_�q6��e>_  r1wv�� ��R�l  ge�b[�mA� ��� SꉁO`N N*w<y^��[�  bv�r1\1g	aNI bN��� ��R�l  S�v�O�OW(N �w N�onb�c$b��a��O` e>W(bbK_Ñ�  O`v�w_�  Y�g�bv�WZ_:N�`'  ON\_�O$[�N�O` O`��N��n)g�cБ� b�}q6_�Y*`%  f�[�`���O`� �  �  �   ascr  ��ޭ