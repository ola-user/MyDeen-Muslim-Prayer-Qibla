import '../models/azkar_item.dart';

class AzkarContent {
  // 1. Morning Azkar (Leaving your verified one here as a test)
  // --- MORNING AZKAR (HISN AL-MUSLIM) ---
  static final List<AzkarItem> morning = [
    // 1. Ayatul Kursi
    AzkarItem(
      arabic: 'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ ۚ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ ۚ لَّهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ ۗ مَن ذَا الَّذِي يَشْفَعُ عِندَهُ إِلَّا بِإِذْنِهِ ۚ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ ۖ وَلَا يُحِيطُونَ بِشَيْءٍ مِّنْ عِلْمِهِ إِلَّا بِمَا شَاءَ ۚ وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضَ ۖ وَلَا يَئُودُهُ حِفْظُهُمَا ۚ وَهُوَ الْعَلِيُّ الْعَظِيمُ',
      transliteration: 'Allaahu laa ilaaha illaa Huwal-Hayyul-Qayyoom, laa ta\'khudhuhu sinatun wa laa nawm, lahu maa fis-samaawaati wa maa fil-ard, man dhal-ladhee yashfa\'u \'indahu illaa bi-idhnih, ya\'lamu maa bayna aydeehim wa maa khalfahum, wa laa yuheetoona bi-shay\'in min \'ilmihi illaa bimaa shaa\', wasi\'a kursiyyuhus-samaawaati wal-ard, wa laa ya\'ooduhu hifdhuhumaa, wa Huwal-\'Aliyyul-\'Adheem.',
      translation: 'Allah - there is no deity except Him, the Ever-Living, the Sustainer of [all] existence. Neither drowsiness overtakes Him nor sleep. To Him belongs whatever is in the heavens and whatever is on the earth. Who is it that can intercede with Him except by His permission? He knows what is [presently] before them and what will be after them, and they encompass not a thing of His knowledge except for what He wills. His Kursi extends over the heavens and the earth, and their preservation tires Him not. And He is the Most High, the Most Great.',
      reference: 'Surah Al-Baqarah 2:255, Al-Hakim 1/562',
      targetCount: 1,
      audioUrl: 'assets/audio/morning_azkar_1.mp3',
    ),
    // 2. The 3 Quls (Al-Ikhlas, Al-Falaq, An-Nas)
    AzkarItem(
      arabic:
          'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ\n'
          'قُلْ هُوَ اللَّهُ أَحَدٌ ۝ اللَّهُ الصَّمَدُ ۝ لَمْ يَلِدْ وَلَمْ يُولَدْ ۝ وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ\n\n'
          'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ\n'
          'قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ ۝ مِن شَرِّ مَا خَلَقَ ۝ وَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ ۝ وَمِن شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ ۝ وَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ\n\n'
          'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ\n'
          'قُلْ أَعُوذُ بِرَبِّ النَّاسِ ۝ مَلِكِ النَّاسِ ۝ إِلَٰهِ النَّاسِ ۝ مِن شَرِّ الْوَسْوَاسِ الْخَنَّاسِ ۝ الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ ۝ مِنَ الْجِنَّةِ وَالنَّاسِ',
      transliteration:
          'Bismillaahir-Rahmaanir-Raheem.\n'
          'Qul huwal-laahu ahad. Allaahus-samad. Lam yalid wa lam yoolad. Wa lam yakul-lahoo kufuwan ahad.\n\n'
          'Bismillaahir-Rahmaanir-Raheem.\n'
          'Qul a\'oodhu bi-rabbil-falaq. Min sharri maa khalaq. Wa min sharri ghaasiqin idhaa waqab. Wa min sharrin-naffaathaati fil-\'uqad. Wa min sharri haasidin idhaa hasad.\n\n'
          'Bismillaahir-Rahmaanir-Raheem.\n'
          'Qul a\'oodhu bi-rabbin-naas. Malikin-naas. Ilaahin-naas. Min sharril-waswaasil-khannaas. Alladhee yuwaswisu fee sudoorin-naas. Minal-jinnati wan-naas.',
      translation:
          'In the name of Allah, the Entirely Merciful, the Especially Merciful.\n'
          'Say, "He is Allah, [who is] One, Allah, the Eternal Refuge. He neither begets nor is born, Nor is there to Him any equivalent."\n\n'
          'In the name of Allah, the Entirely Merciful, the Especially Merciful.\n'
          'Say, "I seek refuge in the Lord of daybreak From the evil of that which He created And from the evil of darkness when it settles And from the evil of the blowers in knots And from the evil of an envier when he envies."\n\n'
          'In the name of Allah, the Entirely Merciful, the Especially Merciful.\n'
          'Say, "I seek refuge in the Lord of mankind, The Sovereign of mankind. The God of mankind, From the evil of the retreating whisperer - Who whispers [evil] into the breasts of mankind - From among the jinn and mankind."',
      reference: 'Surah Al-Ikhlas (112), Al-Falaq (113), An-Nas (114); Abu Dawud 4/322, At-Tirmidhi 5/567',
      audioUrl: 'assets/audio/morning_azkar_2.mp3',
      targetCount: 3,
    ),
    // 3. Asbahnaa wa asbahal-mulku lillaah
    AzkarItem(
      arabic: 'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ، رَبِّ أَسْأَلُكَ خَيْرَ مَا فِي هَذَا الْيَوْمِ وَخَيْرَ مَا بَعْدَهُ، وَأَعُوذُ بِكَ مِنْ شَرِّ مَا فِي هَذَا الْيَوْمِ وَشَرِّ مَا بَعْدَهُ، رَبِّ أَعُوذُ بِكَ مِنَ الْكَسَلِ وَسُوءِ الْكِبَرِ، رَبِّ أَعُوذُ بِكَ مِنْ عَذَابٍ فِي النَّارِ وَعَذَابٍ فِي الْقَبْرِ.',
      transliteration: 'Asbahnaa wa asbahal-mulku lillaah, walhamdu lillaah, laa ilaaha illallaahu wahdahu laa shareeka lahu, lahul-mulku wa lahul-hamdu wa Huwa \'alaa kulli shay\'in Qadeer. Rabbi as\'aluka khayra maa fee haadhal-yawmi wa khayra maa ba\'dahu, wa a\'oodhu bika min sharri maa fee haadhal-yawmi wa sharri maa ba\'dahu, Rabbi a\'oodhu bika minal-kasali wa soo\'il-kibar, Rabbi a\'oodhu bika min \'adhaabin fin-naari wa \'adhaabin fil-qabr.',
      translation: 'We have reached the morning and at this very time unto Allah belongs all sovereignty, and all praise is for Allah. None has the right to be worshipped except Allah, alone, without partner, to Him belongs all sovereignty and praise and He is over all things omnipotent. My Lord, I ask You for the good of this day and the good of that which follows it and I take refuge in You from the evil of this day and the evil of that which follows it. My Lord, I take refuge in You from laziness and helplessness of old age. My Lord, I take refuge in You from torment in the Fire and punishment in the grave.',
      reference: 'Muslim 4/2088',
      targetCount: 1,
      audioUrl: 'assets/audio/morning_azkar_3.mp3',
    ),
    // 4. Allaahumma bika asbahnaa
    AzkarItem(
      arabic: 'اللَّهُمَّ بِكَ أَصْبَحْنَا، وَبِكَ أَمْسَيْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ وَإِلَيْكَ النُّشُورُ.',
      transliteration: 'Allaahumma bika asbahnaa, wa bika amsaynaa, wa bika nahyaa, wa bika namootu wa ilaykan-nushoor.',
      translation: 'O Allah, by Your leave we have reached the morning and by Your leave we have reached the evening, by Your leave we live and die and unto You is our resurrection.',
      reference: 'At-Tirmidhi 5/466',
      targetCount: 1,
      audioUrl: 'assets/audio/morning_azkar_4.mp3',
    ),
    // 5. Sayyidul Istighfar
    AzkarItem(
      arabic: 'اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ، وَأَبُوءُ بِذَنْبِي فَاغْفِرْ لِي فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ.',
      transliteration: 'Allaahumma Anta Rabbee laa ilaaha illaa Ant, khalaqtanee wa ana \'abduka, wa ana \'alaa \'ahdika wa wa\'dika mastata\'t, a\'oodhu bika min sharri maa sana\'t, aboo\'u laka bi-ni\'matika \'alayya, wa aboo\'u bi-dhanbee faghfir lee fa-innahu laa yaghfirudh-dhunooba illaa Ant.',
      translation: 'O Allah, You are my Lord, none has the right to be worshipped except You, You created me and I am Your servant and I abide to Your covenant and promise as best I can, I take refuge in You from the evil of which I have committed. I acknowledge Your favour upon me and I acknowledge my sin, so forgive me, for verily none can forgive sin except You.',
      reference: 'Al-Bukhari 7/150',
      targetCount: 1,
      audioUrl: 'assets/audio/morning_azkar_5.mp3',
    ),
    // 6. Allaahumma innee asbahtu ush-hiduka
    AzkarItem(
      arabic: 'اللَّهُمَّ إِنِّي أَصْبَحْتُ أُشْهِدُكَ، وَأُشْهِدُ حَمَلَةَ عَرْشِكَ، وَمَلَائِكَتَكَ، وَجَمِيعَ خَلْقِكَ، أَنَّكَ أَنْتَ اللَّهُ لَا إِلَهَ إِلَّا أَنْتَ وَحْدَكَ لَا شَرِيكَ لَكَ، وَأَنَّ مُحَمَّدًا عَبْدُكَ وَرَسُولُكَ.',
      transliteration: 'Allaahumma innee asbahtu ush-hiduka, wa ush-hidu hamalata \'arshika, wa malaa\'ikataka, wa jamee\'a khalqika, annaka Antallaahu laa ilaaha illaa Anta wahdaka laa shareeka laka, wa anna Muhammadan \'abduka wa Rasooluk.',
      translation: 'O Allah, verily I have reached the morning and call on You, the bearers of Your throne, Your angels, and all of Your creation to witness that You are Allah, none has the right to be worshipped except You, alone, without partner and that Muhammad is Your Servant and Messenger.',
      reference: 'Abu Dawud 4/317, Al-Bukhari in Al-Adab Al-Mufrad 1201',
      targetCount: 4,
      audioUrl: 'assets/audio/morning_azkar_6.mp3',
    ),
    // 7. Allaahumma maa asbaha bee min ni'matin
    AzkarItem(
      arabic: 'اللَّهُمَّ مَا أَصْبَحَ بِي مِنْ نِعْمَةٍ أَوْ بِأَحَدٍ مِنْ خَلْقِكَ فَمِنْكَ وَحْدَكَ لَا شَرِيكَ لَكَ، فَلَكَ الْحَمْدُ وَلَكَ الشُّكْرُ.',
      transliteration: 'Allaahumma maa asbaha bee min ni\'matin aw bi-ahadin min khalqika fa-minka wahdaka laa shareeka laka, fa-lakal-hamdu wa lakash-shukr.',
      translation: 'O Allah, whatever blessing has been received by me or anyone of Your creation is from You alone, You have no partner. All praise is for You and all thanks is to You.',
      reference: 'Abu Dawud 4/318, An-Nasa\'i in Amalul-Yawmi wal-Laylah 7',
      targetCount: 1,
      audioUrl: 'assets/audio/morning_azkar_7.mp3',
    ),
    // 8. Allaahumma 'aafinee fee badanee
    AzkarItem(
      arabic: 'اللَّهُمَّ عَافِنِي فِي بَدَنِي، اللَّهُمَّ عَافِنِي فِي سَمْعِي، اللَّهُمَّ عَافِنِي فِي بَصَرِي، لَا إِلَهَ إِلَّا أَنْتَ. اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْكُفْرِ، وَالْفَقْرِ، وَأَعُوذُ بِكَ مِنْ عَذَابِ الْقَبْرِ، لَا إِلَهَ إِلَّا أَنْتَ.',
      transliteration: 'Allaahumma \'aafinee fee badanee, Allaahumma \'aafinee fee sam\'ee, Allaahumma \'aafinee fee basaree, laa ilaaha illaa Ant. Allaahumma innee a\'oodhu bika minal-kufri, wal-faqri, wa a\'oodhu bika min \'adhaabil-qabri, laa ilaaha illaa Ant.',
      translation: 'O Allah, grant my body health, O Allah, grant my hearing health, O Allah, grant my sight health. None has the right to be worshipped except You. O Allah, I take refuge with You from disbelief and poverty, and I take refuge with You from the punishment of the grave. None has the right to be worshipped except You.',
      reference: 'Abu Dawud 4/324, Ahmad 5/42',
      targetCount: 3,
      audioUrl: 'assets/audio/morning_azkar_8.mp3',
    ),
    // 9. Hasbiyallaahu laa ilaaha illaa Huwa
    AzkarItem(
      arabic: 'حَسْبِيَ اللَّهُ لَا إِلَهَ إِلَّا هُوَ عَلَيْهِ تَوَكَّلْتُ وَهُوَ رَبُّ الْعَرْشِ الْعَظِيمِ.',
      transliteration: 'Hasbiyallaahu laa ilaaha illaa Huwa \'alayhi tawakkaltu wa Huwa Rabbul-\'Arshil-\'Adheem.',
      translation: 'Allah is sufficient for me, none has the right to be worshipped except Him, upon Him I rely and He is Lord of the Exalted Throne.',
      reference: 'Ibn As-Sunni 71, Abu Dawud 4/321',
      targetCount: 7,
      audioUrl: 'assets/audio/morning_azkar_9.mp3',
    ),
    // 10. Allaahumma innee as'alukal-'afwa wal-'aafiyah
    AzkarItem(
      arabic: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ فِي الدُّنْيَا وَالْآخِرَةِ، اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ: فِي دِينِي وَدُنْيَايَ وَأَهْلِي، وَمَالِي، اللَّهُمَّ اسْتُرْ عَوْرَاتِي، وَآمِنْ رَوْعَاتِي، اللَّهُمَّ احْفَظْنِي مِنْ بَيْنِ يَدَيَّ، وَمِنْ خَلْفِي، وَعَنْ يَمِينِي، وَعَنْ شِمَالِي، وَمِنْ فَوْقِي، وَأَعُوذُ بِعَظَمَتِكَ أَنْ أُغْتَالَ مِنْ تَحْتِي.',
      transliteration: 'Allaahumma innee as\'alukal-\'afwa wal-\'aafiyata fid-dunyaa wal-aakhirah, Allaahumma innee as\'alukal-\'afwa wal-\'aafiyata: fee deenee wa dunyaaya wa ahlee, wa maalee, Allaahummas-tur \'awraatee, wa aamin raw\'aatee, Allaahummah-fadhnee min bayni yadayya, wa min khalfee, wa \'an yameenee, wa \'an shimaalee, wa min fawqee, wa a\'oodhu bi-\'adhamatika an ughtaala min tahtee.',
      translation: 'O Allah, I ask You for pardon and well-being in this life and the next. O Allah, I ask You for pardon and well-being in my religious and worldly affairs, and my family and my wealth. O Allah, veil my weaknesses and set at ease my dismay. O Allah, preserve me from the front and from behind and on my right and on my left and from above, and I take refuge with You lest I be swallowed up by the earth.',
      reference: 'Abu Dawud 5074, Ibn Majah 2/332',
      targetCount: 1,
      audioUrl: 'assets/audio/morning_azkar_10.mp3',
    ),
    // 11. Allaahumma 'Aalimal-ghaybi wash-shahaadah
    AzkarItem(
      arabic: 'اللَّهُمَّ عَالِمَ الْغَيْبِ وَالشَّهَادَةِ فَاطِرَ السَّمَاوَاتِ وَالْأَرْضِ، رَبَّ كُلِّ شَيْءٍ وَمَلِيكَهُ، أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا أَنْتَ، أَعُوذُ بِكَ مِنْ شَرِّ نَفْسِي، وَمِنْ شَرِّ الشَّيْطَانِ وَشِرْكِهِ، وَأَنْ أَقْتَرِفَ عَلَى نَفْسِي سُوءًا، أَوْ أَجُرَّهُ إِلَى مُسْلِمٍ.',
      transliteration: 'Allaahumma \'Aalimal-ghaybi wash-shahaadati faatiras-samaawaati wal-ard, Rabba kulli shay\'in wa maleekah, ash-hadu an laa ilaaha illaa Ant, a\'oodhu bika min sharri nafsee, wa min sharrish-shaytaani wa shirkih, wa an aqtarifa \'alaa nafsee soo\'an, aw ajurrahu ilaa Muslim.',
      translation: 'O Allah, Knower of the unseen and the evident, Maker of the heavens and the earth, Lord of everything and its Master, I bear witness that there is none worthy of worship but You. I seek refuge in You from the evil of my soul and from the evil of Shaytan and his helpers, and from bringing evil upon myself or harming any Muslim.',
      reference: 'At-Tirmidhi 5/467, Abu Dawud 4/317',
      targetCount: 1,
      audioUrl: 'assets/audio/morning_azkar_11.mp3',
    ),
    // 12. Bismillaahil-ladhee laa yadurru ma'asmihi shay'un
    AzkarItem(
      arabic: 'بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ.',
      transliteration: 'Bismillaahil-ladhee laa yadurru ma\'asmihi shay\'un fil-ardi wa laa fis-samaa\'i wa Huwas-Samee\'ul-\'Aleem.',
      translation: 'In the name of Allah with whose name nothing is harmed on earth nor in the heavens and He is The All-Seeing, The All-Knowing.',
      reference: 'Abu Dawud 4/323, At-Tirmidhi 5/465',
      targetCount: 3,
      audioUrl: 'assets/audio/morning_azkar_12.mp3',
    ),
    // 13. Radeetu billaahi Rabban
    AzkarItem(
      arabic: 'رَضِيتُ بِاللَّهِ رَبًّا، وَبِالْإِسْلَامِ دِينًا، وَبِمُحَمَّدٍ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ نَبِيًّا.',
      transliteration: 'Radeetu billaahi Rabban, wa bil-Islaami deenan, wa bi-Muhammadin sallallaahu \'alayhi wa sallama nabiyyaa.',
      translation: 'I am pleased with Allah as a Lord, and Islam as a religion and Muhammad peace and blessings be upon him as a Prophet.',
      reference: 'Ahmad 4/337, An-Nasa\'i in Amalul-Yawmi wal-Laylah 4',
      targetCount: 3,
      audioUrl: 'assets/audio/morning_azkar_13.mp3',
    ),
    // 14. Yaa Hayyu yaa Qayyoomu bi-rahmatika astagheeth
    AzkarItem(
      arabic: 'يَا حَيُّ يَا قَيُّومُ بِرَحْمَتِكَ أَسْتَغِيثُ أَصْلِحْ لِي شَأْنِي كُلَّهُ وَلَا تَكِلْنِي إِلَى نَفْسِي طَرْفَةَ عَيْنٍ.',
      transliteration: 'Yaa Hayyu yaa Qayyoomu bi-rahmatika astagheeth, aslih lee sha\'nee kullahu wa laa takilnee ilaa nafsee tarfata \'ayn.',
      translation: 'O Ever Living, O Self-Subsisting and Supporter of all, by Your mercy I seek assistance, rectify for me all of my affairs and do not leave me to myself, even for the blink of an eye.',
      reference: 'Al-Hakim 1/545',
      targetCount: 1,
      audioUrl: 'assets/audio/morning_azkar_14.mp3',
    ),
    // 15. Asbahnaa wa asbahal-mulku lillaahi Rabbil-'aalameen
    AzkarItem(
      arabic: 'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ رَبِّ الْعَالَمِينَ، اللَّهُمَّ إِنِّي أَسْأَلُكَ خَيْرَ هَذَا الْيَوْمِ: فَتْحَهُ، وَنَصْرَهُ، وَنُورَهُ، وَبَرَكَتَهُ، وَهُدَاهُ، وَأَعُوذُ بِكَ مِنْ شَرِّ مَا فِيهِ وَشَرِّ مَا بَعْدَهُ.',
      transliteration: 'Asbahnaa wa asbahal-mulku lillaahi Rabbil-\'aalameen, Allaahumma innee as\'aluka khayra haadhal-yawm: fathahu, wa nasrahu, wa noorahu, wa barakatahu, wa hudaah, wa a\'oodhu bika min sharri maa feehi wa sharri maa ba\'dah.',
      translation: 'We have reached the morning and at this very time all sovereignty belongs to Allah, Lord of the worlds. O Allah, I ask You for the good of this day, its triumphs and its victories, its light and its blessings and its guidance, and I take refuge in You from the evil of this day and the evil that follows it.',
      reference: 'Abu Dawud 4/322',
      targetCount: 1,
      audioUrl: 'assets/audio/morning_azkar_15.mp3',
    ),
    // 16. Asbahnaa 'alaa fitratil-Islaam
    AzkarItem(
      arabic: 'أَصْبَحْنَا عَلَى فِطْرَةِ الْإِسْلَامِ، وَعَلَى كَلِمَةِ الْإِخْلَاصِ، وَعَلَى دِينِ نَبِيِّنَا مُحَمَّدٍ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ، وَعَلَى مِلَّةِ أَبِينَا إِبْرَاهِيمَ، حَنِيفًا مُسْلِمًا وَمَا كَانَ مِنَ الْمُشْرِكِينَ.',
      transliteration: 'Asbahnaa \'alaa fitratil-Islaam, wa \'alaa kalimatil-ikhlaas, wa \'alaa deeni nabiyyinaa Muhammadin sallallaahu \'alayhi wa sallam, wa \'alaa millati abeenaa Ibraaheem, haneefan Musliman wa maa kaana minal-mushrikeen.',
      translation: 'We rise upon the fitrah of Islam, and the word of pure faith, and upon the religion of our Prophet Muhammad peace and blessings be upon him and the religion of our forefather Ibrahim, who was a Muslim and of true faith and was not of those who associate others with Allah.',
      reference: 'Ahmad 3/406, Ibn As-Sunni 34',
      targetCount: 1,
      audioUrl: 'assets/audio/morning_azkar_16.mp3',
    ),
    // 17. Subhaanallaahi wa bi-hamdihi
    AzkarItem(
      arabic: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ.',
      transliteration: 'Subhaanallaahi wa bi-hamdih.',
      translation: 'How perfect Allah is and I praise Him.',
      reference: 'Muslim 4/2071',
      targetCount: 100,
      audioUrl: 'assets/audio/morning_azkar_17.mp3',
    ),
    // 18. Laa ilaaha illallaahu wahdahu laa shareeka lahu (10 times)
    AzkarItem(
      arabic: 'لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ، وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ.',
      transliteration: 'Laa ilaaha illallaahu wahdahu laa shareeka lahu, lahul-mulku wa lahul-hamdu, wa Huwa \'alaa kulli shay\'in Qadeer.',
      translation: 'None has the right to be worshipped except Allah, alone, without partner, to Him belongs all sovereignty and praise, and He is over all things omnipotent.',
      reference: 'An-Nasa\'i in Amalul-Yawmi wal-Laylah 24',
      targetCount: 10,
      audioUrl: 'assets/audio/morning_azkar_18.mp3',
    ),
    // 19. Laa ilaaha illallaahu wahdahu laa shareeka lahu (100 times)
    AzkarItem(
      arabic: 'لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ، وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ.',
      transliteration: 'Laa ilaaha illallaahu wahdahu laa shareeka lahu, lahul-mulku wa lahul-hamdu, wa Huwa \'alaa kulli shay\'in Qadeer.',
      translation: 'None has the right to be worshipped except Allah, alone, without partner, to Him belongs all sovereignty and praise, and He is over all things omnipotent.',
      reference: 'Al-Bukhari 4/95, Muslim 4/2071',
      targetCount: 100,
      audioUrl: 'assets/audio/morning_azkar_19.mp3',
    ),
    // 20. Subhaanallaahi wa bi-hamdihi: 'adada khalqihi
    AzkarItem(
      arabic: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ: عَدَدَ خَلْقِهِ، وَرِضَا نَفْسِهِ، وَزِنَةَ عَرْشِهِ، وَمِدَادَ كَلِمَاتِهِ.',
      transliteration: 'Subhaanallaahi wa bi-hamdihi: \'adada khalqihi, wa ridaa nafsihi, wa zinata \'arshihi, wa midaada kalimaatih.',
      translation: 'How perfect Allah is and I praise Him by the number of His creation and His pleasure, and by the weight of His throne, and the ink of His words.',
      reference: 'Muslim 4/2090',
      targetCount: 3,
    ),
    // 21. Allaahumma innee as'aluka 'ilman naafi'an (Morning specific)
    AzkarItem(
      arabic: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ عِلْمًا نَافِعًا، وَرِزْقًا طَيِّبًا، وَعَمَلًا مُتَقَبَّلًا.',
      transliteration: 'Allaahumma innee as\'aluka \'ilman naafi\'an, wa rizqan tayyiban, wa \'amalan mutaqabbalan.',
      translation: 'O Allah, I ask You for knowledge which is beneficial and sustenance which is good, and deeds which are acceptable.',
      reference: 'Ibn As-Sunni 54, Ibn Majah 925',
      targetCount: 1,
      audioUrl: 'assets/audio/morning_azkar_21.mp3',
    ),
    // 22. Astaghfirullaaha wa atoobu ilayh
    AzkarItem(
      arabic: 'أَسْتَغْفِرُ اللَّهَ وَأَتُوبُ إِلَيْهِ.',
      transliteration: 'Astaghfirullaaha wa atoobu ilayh.',
      translation: 'I seek the forgiveness of Allah and repent to Him.',
      reference: 'Al-Bukhari in Fath Al-Bari 11/101, Muslim 4/2075',
      targetCount: 100,
      audioUrl: 'assets/audio/morning_azkar_22.mp3',
    ),
    // 23. Allaahumma salli wa sallim 'alaa nabiyyinaa Muhammad
    AzkarItem(
      arabic: 'اللَّهُمَّ صَلِّ وَسَلِّمْ عَلَى نَبِيِّنَا مُحَمَّدٍ.',
      transliteration: 'Allaahumma salli wa sallim \'alaa nabiyyinaa Muhammad.',
      translation: 'O Allah, send prayers and peace upon our Prophet Muhammad.',
      reference: 'At-Tabarani in Al-Kabir',
      targetCount: 10,
      audioUrl: 'assets/audio/morning_azkar_23.mp3',
    ),
  ];

  // --- EVENING AZKAR (HISN AL-MUSLIM) ---
  static final List<AzkarItem> evening = [
    // 1. Ayatul Kursi
    AzkarItem(
      arabic: 'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ ۚ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ ۚ لَّهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ ۗ مَن ذَا الَّذِي يَشْفَعُ عِندَهُ إِلَّا بِإِذْنِهِ ۚ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ ۖ وَلَا يُحِيطُونَ بِشَيْءٍ مِّنْ عِلْمِهِ إِلَّا بِمَا شَاءَ ۚ وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضَ ۖ وَلَا يَئُودُهُ حِفْظُهُمَا ۚ وَهُوَ الْعَلِيُّ الْعَظِيمُ',
      transliteration: 'Allaahu laa ilaaha illaa Huwal-Hayyul-Qayyoom, laa ta\'khudhuhu sinatun wa laa nawm, lahu maa fis-samaawaati wa maa fil-ard, man dhal-ladhee yashfa\'u \'indahu illaa bi-idhnih, ya\'lamu maa bayna aydeehim wa maa khalfahum, wa laa yuheetoona bi-shay\'in min \'ilmihi illaa bimaa shaa\', wasi\'a kursiyyuhus-samaawaati wal-ard, wa laa ya\'ooduhu hifdhuhumaa, wa Huwal-\'Aliyyul-\'Adheem.',
      translation: 'Allah - there is no deity except Him, the Ever-Living, the Sustainer of [all] existence. Neither drowsiness overtakes Him nor sleep. To Him belongs whatever is in the heavens and whatever is on the earth. Who is it that can intercede with Him except by His permission? He knows what is [presently] before them and what will be after them, and they encompass not a thing of His knowledge except for what He wills. His Kursi extends over the heavens and the earth, and their preservation tires Him not. And He is the Most High, the Most Great.',
      reference: 'Surah Al-Baqarah 2:255, Al-Hakim 1/562',
      targetCount: 1,
      audioUrl: 'assets/audio/evening_azkar_1.mp3',
    ),
    // 2. The 3 Quls (Al-Ikhlas, Al-Falaq, An-Nas)
    AzkarItem(
      arabic:
          'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ\n'
          'قُلْ هُوَ اللَّهُ أَحَدٌ ۝ اللَّهُ الصَّمَدُ ۝ لَمْ يَلِدْ وَلَمْ يُولَدْ ۝ وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ\n\n'
          'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ\n'
          'قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ ۝ مِن شَرِّ مَا خَلَقَ ۝ وَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ ۝ وَمِن شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ ۝ وَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ\n\n'
          'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ\n'
          'قُلْ أَعُوذُ بِرَبِّ النَّاسِ ۝ مَلِكِ النَّاسِ ۝ إِلَٰهِ النَّاسِ ۝ مِن شَرِّ الْوَسْوَاسِ الْخَنَّاسِ ۝ الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ ۝ مِنَ الْجِنَّةِ وَالنَّاسِ',
      transliteration:
          'Bismillaahir-Rahmaanir-Raheem.\n'
          'Qul huwal-laahu ahad. Allaahus-samad. Lam yalid wa lam yoolad. Wa lam yakul-lahoo kufuwan ahad.\n\n'
          'Bismillaahir-Rahmaanir-Raheem.\n'
          'Qul a\'oodhu bi-rabbil-falaq. Min sharri maa khalaq. Wa min sharri ghaasiqin idhaa waqab. Wa min sharrin-naffaathaati fil-\'uqad. Wa min sharri haasidin idhaa hasad.\n\n'
          'Bismillaahir-Rahmaanir-Raheem.\n'
          'Qul a\'oodhu bi-rabbin-naas. Malikin-naas. Ilaahin-naas. Min sharril-waswaasil-khannaas. Alladhee yuwaswisu fee sudoorin-naas. Minal-jinnati wan-naas.',
      translation:
          'In the name of Allah, the Entirely Merciful, the Especially Merciful.\n'
          'Say, "He is Allah, [who is] One, Allah, the Eternal Refuge. He neither begets nor is born, Nor is there to Him any equivalent."\n\n'
          'In the name of Allah, the Entirely Merciful, the Especially Merciful.\n'
          'Say, "I seek refuge in the Lord of daybreak From the evil of that which He created And from the evil of darkness when it settles And from the evil of the blowers in knots And from the evil of an envier when he envies."\n\n'
          'In the name of Allah, the Entirely Merciful, the Especially Merciful.\n'
          'Say, "I seek refuge in the Lord of mankind, The Sovereign of mankind. The God of mankind, From the evil of the retreating whisperer - Who whispers [evil] into the breasts of mankind - From among the jinn and mankind."',
      reference: 'Surah Al-Ikhlas (112), Al-Falaq (113), An-Nas (114); Abu Dawud 4/322, At-Tirmidhi 5/567',
      targetCount: 3,
      audioUrl: 'assets/audio/evening_azkar_2.mp3',
    ),
    // 3. Amsaynaa wa amsal-mulku lillaah
    AzkarItem(
      arabic: 'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ، رَبِّ أَسْأَلُكَ خَيْرَ مَا فِي هَذِهِ اللَّيْلَةِ وَخَيْرَ مَا بَعْدَهَا، وَأَعُوذُ بِكَ مِنْ شَرِّ مَا فِي هَذِهِ اللَّيْلَةِ وَشَرِّ مَا بَعْدَهَا، رَبِّ أَعُوذُ بِكَ مِنَ الْكَسَلِ وَسُوءِ الْكِبَرِ، رَبِّ أَعُوذُ بِكَ مِنْ عَذَابٍ فِي النَّارِ وَعَذَابٍ فِي الْقَبْرِ.',
      transliteration: 'Amsaynaa wa amsal-mulku lillaah, walhamdu lillaah, laa ilaaha illallaahu wahdahu laa shareeka lahu, lahul-mulku wa lahul-hamdu wa Huwa \'alaa kulli shay\'in Qadeer. Rabbi as\'aluka khayra maa fee haadhihil-laylati wa khayra maa ba\'dahaa, wa a\'oodhu bika min sharri maa fee haadhihil-laylati wa sharri maa ba\'dahaa, Rabbi a\'oodhu bika minal-kasali wa soo\'il-kibar, Rabbi a\'oodhu bika min \'adhaabin fin-naari wa \'adhaabin fil-qabr.',
      translation: 'We have reached the evening and at this very time unto Allah belongs all sovereignty, and all praise is for Allah. None has the right to be worshipped except Allah, alone, without partner, to Him belongs all sovereignty and praise and He is over all things omnipotent. My Lord, I ask You for the good of this night and the good of that which follows it and I take refuge in You from the evil of this night and the evil of that which follows it. My Lord, I take refuge in You from laziness and helplessness of old age. My Lord, I take refuge in You from torment in the Fire and punishment in the grave.',
      reference: 'Muslim 4/2088',
      targetCount: 1,
      audioUrl: 'assets/audio/evening_azkar_3.mp3',
    ),
    // 4. Allaahumma bika amsaynaa
    AzkarItem(
      arabic: 'اللَّهُمَّ بِكَ أَمْسَيْنَا، وَبِكَ أَصْبَحْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ وَإِلَيْكَ الْمَصِيرُ.',
      transliteration: 'Allaahumma bika amsaynaa, wa bika asbahnaa, wa bika nahyaa, wa bika namootu wa ilaykal-maseer.',
      translation: 'O Allah, by Your leave we have reached the evening and by Your leave we have reached the morning, by Your leave we live and die and unto You is our return.',
      reference: 'At-Tirmidhi 5/466',
      targetCount: 1,
      audioUrl: 'assets/audio/evening_azkar_4.mp3',
    ),
    // 5. Sayyidul Istighfar
    AzkarItem(
      arabic: 'اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ، وَأَبُوءُ بِذَنْبِي فَاغْفِرْ لِي فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ.',
      transliteration: 'Allaahumma Anta Rabbee laa ilaaha illaa Ant, khalaqtanee wa ana \'abduka, wa ana \'alaa \'ahdika wa wa\'dika mastata\'t, a\'oodhu bika min sharri maa sana\'t, aboo\'u laka bi-ni\'matika \'alayya, wa aboo\'u bi-dhanbee faghfir lee fa-innahu laa yaghfirudh-dhunooba illaa Ant.',
      translation: 'O Allah, You are my Lord, none has the right to be worshipped except You, You created me and I am Your servant and I abide to Your covenant and promise as best I can, I take refuge in You from the evil of which I have committed. I acknowledge Your favour upon me and I acknowledge my sin, so forgive me, for verily none can forgive sin except You.',
      reference: 'Al-Bukhari 7/150',
      targetCount: 1,
      audioUrl: 'assets/audio/evening_azkar_5.mp3',
    ),
    // 6. Allaahumma innee amsaytu ush-hiduka
    AzkarItem(
      arabic: 'اللَّهُمَّ إِنِّي أَمْسَيْتُ أُشْهِدُكَ، وَأُشْهِدُ حَمَلَةَ عَرْشِكَ، وَمَلَائِكَتَكَ، وَجَمِيعَ خَلْقِكَ، أَنَّكَ أَنْتَ اللَّهُ لَا إِلَهَ إِلَّا أَنْتَ وَحْدَكَ لَا شَرِيكَ لَكَ، وَأَنَّ مُحَمَّدًا عَبْدُكَ وَرَسُولُكَ.',
      transliteration: 'Allaahumma innee amsaytu ush-hiduka, wa ush-hidu hamalata \'arshika, wa malaa\'ikataka, wa jamee\'a khalqika, annaka Antallaahu laa ilaaha illaa Anta wahdaka laa shareeka laka, wa anna Muhammadan \'abduka wa Rasooluk.',
      translation: 'O Allah, verily I have reached the evening and call on You, the bearers of Your throne, Your angels, and all of Your creation to witness that You are Allah, none has the right to be worshipped except You, alone, without partner and that Muhammad is Your Servant and Messenger.',
      reference: 'Abu Dawud 4/317, Al-Bukhari in Al-Adab Al-Mufrad 1201',
      targetCount: 4,
      audioUrl: 'assets/audio/evening_azkar_6.mp3',
    ),
    // 7. Allaahumma maa amsaa bee min ni'matin
    AzkarItem(
      arabic: 'اللَّهُمَّ مَا أَمْسَى بِي مِنْ نِعْمَةٍ أَوْ بِأَحَدٍ مِنْ خَلْقِكَ فَمِنْكَ وَحْدَكَ لَا شَرِيكَ لَكَ، فَلَكَ الْحَمْدُ وَلَكَ الشُّكْرُ.',
      transliteration: 'Allaahumma maa amsaa bee min ni\'matin aw bi-ahadin min khalqika fa-minka wahdaka laa shareeka laka, fa-lakal-hamdu wa lakash-shukr.',
      translation: 'O Allah, whatever blessing has been received by me or anyone of Your creation is from You alone, You have no partner. All praise is for You and all thanks is to You.',
      reference: 'Abu Dawud 4/318, An-Nasa\'i in Amalul-Yawmi wal-Laylah 7',
      targetCount: 1,
      audioUrl: 'assets/audio/evening_azkar_7.mp3',
    ),
    // 8. Allaahumma 'aafinee fee badanee
    AzkarItem(
      arabic: 'اللَّهُمَّ عَافِنِي فِي بَدَنِي، اللَّهُمَّ عَافِنِي فِي سَمْعِي، اللَّهُمَّ عَافِنِي فِي بَصَرِي، لَا إِلَهَ إِلَّا أَنْتَ. اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْكُفْرِ، وَالْفَقْرِ، وَأَعُوذُ بِكَ مِنْ عَذَابِ الْقَبْرِ، لَا إِلَهَ إِلَّا أَنْتَ.',
      transliteration: 'Allaahumma \'aafinee fee badanee, Allaahumma \'aafinee fee sam\'ee, Allaahumma \'aafinee fee basaree, laa ilaaha illaa Ant. Allaahumma innee a\'oodhu bika minal-kufri, wal-faqri, wa a\'oodhu bika min \'adhaabil-qabri, laa ilaaha illaa Ant.',
      translation: 'O Allah, grant my body health, O Allah, grant my hearing health, O Allah, grant my sight health. None has the right to be worshipped except You. O Allah, I take refuge with You from disbelief and poverty, and I take refuge with You from the punishment of the grave. None has the right to be worshipped except You.',
      reference: 'Abu Dawud 4/324, Ahmad 5/42',
      targetCount: 3,
      audioUrl: 'assets/audio/evening_azkar_8.mp3',
    ),
    // 9. Hasbiyallaahu laa ilaaha illaa Huwa
    AzkarItem(
      arabic: 'حَسْبِيَ اللَّهُ لَا إِلَهَ إِلَّا هُوَ عَلَيْهِ تَوَكَّلْتُ وَهُوَ رَبُّ الْعَرْشِ الْعَظِيمِ.',
      transliteration: 'Hasbiyallaahu laa ilaaha illaa Huwa \'alayhi tawakkaltu wa Huwa Rabbul-\'Arshil-\'Adheem.',
      translation: 'Allah is sufficient for me, none has the right to be worshipped except Him, upon Him I rely and He is Lord of the Exalted Throne.',
      reference: 'Ibn As-Sunni 71, Abu Dawud 4/321',
      targetCount: 7,
      audioUrl: 'assets/audio/evening_azkar_9.mp3',
    ),
    // 10. Allaahumma innee as'alukal-'afwa wal-'aafiyah
    AzkarItem(
      arabic: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ فِي الدُّنْيَا وَالْآخِرَةِ، اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ: فِي دِينِي وَدُنْيَايَ وَأَهْلِي، وَمَالِي، اللَّهُمَّ اسْتُرْ عَوْرَاتِي، وَآمِنْ رَوْعَاتِي، اللَّهُمَّ احْفَظْنِي مِنْ بَيْنِ يَدَيَّ، وَمِنْ خَلْفِي، وَعَنْ يَمِينِي، وَعَنْ شِمَالِي، وَمِنْ فَوْقِي، وَأَعُوذُ بِعَظَمَتِكَ أَنْ أُغْتَالَ مِنْ تَحْتِي.',
      transliteration: 'Allaahumma innee as\'alukal-\'afwa wal-\'aafiyata fid-dunyaa wal-aakhirah, Allaahumma innee as\'alukal-\'afwa wal-\'aafiyata: fee deenee wa dunyaaya wa ahlee, wa maalee, Allaahummas-tur \'awraatee, wa aamin raw\'aatee, Allaahummah-fadhnee min bayni yadayya, wa min khalfee, wa \'an yameenee, wa \'an shimaalee, wa min fawqee, wa a\'oodhu bi-\'adhamatika an ughtaala min tahtee.',
      translation: 'O Allah, I ask You for pardon and well-being in this life and the next. O Allah, I ask You for pardon and well-being in my religious and worldly affairs, and my family and my wealth. O Allah, veil my weaknesses and set at ease my dismay. O Allah, preserve me from the front and from behind and on my right and on my left and from above, and I take refuge with You lest I be swallowed up by the earth.',
      reference: 'Abu Dawud 5074, Ibn Majah 2/332',
      targetCount: 1,
      audioUrl: 'assets/audio/evening_azkar_10.mp3',
    ),
    // 11. Allaahumma 'Aalimal-ghaybi wash-shahaadah
    AzkarItem(
      arabic: 'اللَّهُمَّ عَالِمَ الْغَيْبِ وَالشَّهَادَةِ فَاطِرَ السَّمَاوَاتِ وَالْأَرْضِ، رَبَّ كُلِّ شَيْءٍ وَمَلِيكَهُ، أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا أَنْتَ، أَعُوذُ بِكَ مِنْ شَرِّ نَفْسِي، وَمِنْ شَرِّ الشَّيْطَانِ وَشِرْكِهِ، وَأَنْ أَقْتَرِفَ عَلَى نَفْسِي سُوءًا، أَوْ أَجُرَّهُ إِلَى مُسْلِمٍ.',
      transliteration: 'Allaahumma \'Aalimal-ghaybi wash-shahaadati faatiras-samaawaati wal-ard, Rabba kulli shay\'in wa maleekah, ash-hadu an laa ilaaha illaa Ant, a\'oodhu bika min sharri nafsee, wa min sharrish-shaytaani wa shirkih, wa an aqtarifa \'alaa nafsee soo\'an, aw ajurrahu ilaa Muslim.',
      translation: 'O Allah, Knower of the unseen and the evident, Maker of the heavens and the earth, Lord of everything and its Master, I bear witness that there is none worthy of worship but You. I seek refuge in You from the evil of my soul and from the evil of Shaytan and his helpers, and from bringing evil upon myself or harming any Muslim.',
      reference: 'At-Tirmidhi 5/467, Abu Dawud 4/317',
      targetCount: 1,
      audioUrl: 'assets/audio/evening_azkar_11.mp3',
    ),
    // 12. Bismillaahil-ladhee laa yadurru ma'asmihi shay'un
    AzkarItem(
      arabic: 'بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ.',
      transliteration: 'Bismillaahil-ladhee laa yadurru ma\'asmihi shay\'un fil-ardi wa laa fis-samaa\'i wa Huwas-Samee\'ul-\'Aleem.',
      translation: 'In the name of Allah with whose name nothing is harmed on earth nor in the heavens and He is The All-Seeing, The All-Knowing.',
      reference: 'Abu Dawud 4/323, At-Tirmidhi 5/465',
      targetCount: 3,
      audioUrl: 'assets/audio/evening_azkar_12.mp3',
    ),
    // 13. Radeetu billaahi Rabban
    AzkarItem(
      arabic: 'رَضِيتُ بِاللَّهِ رَبًّا، وَبِالْإِسْلَامِ دِينًا، وَبِمُحَمَّدٍ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ نَبِيًّا.',
      transliteration: 'Radeetu billaahi Rabban, wa bil-Islaami deenan, wa bi-Muhammadin sallallaahu \'alayhi wa sallama nabiyyaa.',
      translation: 'I am pleased with Allah as a Lord, and Islam as a religion and Muhammad peace and blessings be upon him as a Prophet.',
      reference: 'Ahmad 4/337, An-Nasa\'i in Amalul-Yawmi wal-Laylah 4',
      targetCount: 3,
      audioUrl: 'assets/audio/evening_azkar_13.mp3',
    ),
    // 14. Yaa Hayyu yaa Qayyoomu bi-rahmatika astagheeth
    AzkarItem(
      arabic: 'يَا حَيُّ يَا قَيُّومُ بِرَحْمَتِكَ أَسْتَغِيثُ أَصْلِحْ لِي شَأْنِي كُلَّهُ وَلَا تَكِلْنِي إِلَى نَفْسِي طَرْفَةَ عَيْنٍ.',
      transliteration: 'Yaa Hayyu yaa Qayyoomu bi-rahmatika astagheeth, aslih lee sha\'nee kullahu wa laa takilnee ilaa nafsee tarfata \'ayn.',
      translation: 'O Ever Living, O Self-Subsisting and Supporter of all, by Your mercy I seek assistance, rectify for me all of my affairs and do not leave me to myself, even for the blink of an eye.',
      reference: 'Al-Hakim 1/545',
      targetCount: 1,
      audioUrl: 'assets/audio/evening_azkar_14.mp3',
    ),
    // 15. Amsaynaa wa amsal-mulku lillaahi Rabbil-'aalameen
    AzkarItem(
      arabic: 'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ رَبِّ الْعَالَمِينَ، اللَّهُمَّ إِنِّي أَسْأَلُكَ خَيْرَ هَذِهِ اللَّيْلَةِ: فَتْحَهَا، وَنَصْرَهَا، وَنُورَهَا، وَبَرَكَتَهَا، وَهُدَاهَا، وَأَعُوذُ بِكَ مِنْ شَرِّ مَا فِيهَا وَشَرِّ مَا بَعْدَهَا.',
      transliteration: 'Amsaynaa wa amsal-mulku lillaahi Rabbil-\'aalameen, Allaahumma innee as\'aluka khayra haadhihil-laylah: fathahaa, wa nasrahaa, wa noorahaa, wa barakatahaa, wa hudaahaa, wa a\'oodhu bika min sharri maa feehaa wa sharri maa ba\'dahaa.',
      translation: 'We have reached the evening and at this very time all sovereignty belongs to Allah, Lord of the worlds. O Allah, I ask You for the good of this night, its triumphs and its victories, its light and its blessings and its guidance, and I take refuge in You from the evil of this night and the evil that follows it.',
      reference: 'Abu Dawud 4/322',
      targetCount: 1,
      audioUrl: 'assets/audio/evening_azkar_15.mp3',
    ),
    // 16. Amsaynaa 'alaa fitratil-Islaam
    AzkarItem(
      arabic: 'أَمْسَيْنَا عَلَى فِطْرَةِ الْإِسْلَامِ، وَعَلَى كَلِمَةِ الْإِخْلَاصِ، وَعَلَى دِينِ نَبِيِّنَا مُحَمَّدٍ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ، وَعَلَى مِلَّةِ أَبِينَا إِبْرَاهِيمَ، حَنِيفًا مُسْلِمًا وَمَا كَانَ مِنَ الْمُشْرِكِينَ.',
      transliteration: 'Amsaynaa \'alaa fitratil-Islaam, wa \'alaa kalimatil-ikhlaas, wa \'alaa deeni nabiyyinaa Muhammadin sallallaahu \'alayhi wa sallam, wa \'alaa millati abeenaa Ibraaheem, haneefan Musliman wa maa kaana minal-mushrikeen.',
      translation: 'We end this day upon the fitrah of Islam, and the word of pure faith, and upon the religion of our Prophet Muhammad peace and blessings be upon him and the religion of our forefather Ibrahim, who was a Muslim and of true faith and was not of those who associate others with Allah.',
      reference: 'Ahmad 3/406, Ibn As-Sunni 34',
      targetCount: 1,
      audioUrl: 'assets/audio/evening_azkar_16.mp3',
    ),
    // 17. Subhaanallaahi wa bi-hamdihi
    AzkarItem(
      arabic: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ.',
      transliteration: 'Subhaanallaahi wa bi-hamdih.',
      translation: 'How perfect Allah is and I praise Him.',
      reference: 'Muslim 4/2071',
      targetCount: 100,
      audioUrl: 'assets/audio/evening_azkar_17.mp3',
    ),
    // 18. Laa ilaaha illallaahu wahdahu laa shareeka lahu (10 times)
    AzkarItem(
      arabic: 'لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ، وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ.',
      transliteration: 'Laa ilaaha illallaahu wahdahu laa shareeka lahu, lahul-mulku wa lahul-hamdu, wa Huwa \'alaa kulli shay\'in Qadeer.',
      translation: 'None has the right to be worshipped except Allah, alone, without partner, to Him belongs all sovereignty and praise, and He is over all things omnipotent.',
      reference: 'An-Nasa\'i in Amalul-Yawmi wal-Laylah 24',
      targetCount: 10,
      audioUrl: 'assets/audio/evening_azkar_18.mp3',
    ),
    // 19. Subhaanallaahi wa bi-hamdihi: 'adada khalqihi
    AzkarItem(
      arabic: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ: عَدَدَ خَلْقِهِ، وَرِضَا نَفْسِهِ، وَزِنَةَ عَرْشِهِ، وَمِدَادَ كَلِمَاتِهِ.',
      transliteration: 'Subhaanallaahi wa bi-hamdihi: \'adada khalqihi, wa ridaa nafsihi, wa zinata \'arshihi, wa midaada kalimaatih.',
      translation: 'How perfect Allah is and I praise Him by the number of His creation and His pleasure, and by the weight of His throne, and the ink of His words.',
      reference: 'Muslim 4/2090',
      targetCount: 3,
      audioUrl: 'assets/audio/evening_azkar_19.mp3',
    ),
    // 20. A'oodhu bi-kalimaatillaahit-taammaati min sharri maa khalaq (Evening specific)
    AzkarItem(
      arabic: 'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ.',
      transliteration:
          'A\'oodhu bi-kalimaatillaahit-taammaati min sharri maa khalaq.',
      translation: 'I seek refuge in the Perfect Words of Allah from the evil of what He has created.',
      reference: 'Ahmad 2/290, An-Nasa\'i in Amalul-Yawmi wal-Laylah 590',
      targetCount: 3,
      audioUrl: 'assets/audio/evening_azkar_20.mp3',
    ),
    // 21. Astaghfirullaaha wa atoobu ilayh
    AzkarItem(
      arabic: 'أَسْتَغْفِرُ اللَّهَ وَأَتُوبُ إِلَيْهِ.',
      transliteration: 'Astaghfirullaaha wa atoobu ilayh.',
      translation: 'I seek the forgiveness of Allah and repent to Him.',
      reference: 'Al-Bukhari in Fath Al-Bari 11/101, Muslim 4/2075',
      targetCount: 100,
      audioUrl: 'assets/audio/evening_azkar_21.mp3',
    ),
    // 22. Allaahumma salli wa sallim 'alaa nabiyyinaa Muhammad
    AzkarItem(
      arabic: 'اللَّهُمَّ صَلِّ وَسَلِّمْ عَلَى نَبِيِّنَا مُحَمَّدٍ.',
      transliteration: 'Allaahumma salli wa sallim \'alaa nabiyyinaa Muhammad.',
      translation: 'O Allah, send prayers and peace upon our Prophet Muhammad.',
      reference: 'At-Tabarani in Al-Kabir',
      targetCount: 10,
      audioUrl: 'assets/audio/evening_azkar_22.mp3',
    ),
  ];

  // --- BEFORE SLEEPING AZKAR (HISN AL-MUSLIM CH. 28) ---
  static final List<AzkarItem> beforeSleeping = [
    // 1. The 3 Quls (Ikhlas, Falaq, Nas) (Hisn al-Muslim #99)
    AzkarItem(
      arabic:
          'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ\n'
          'قُلْ هُوَ اللَّهُ أَحَدٌ ۝ اللَّهُ الصَّمَدُ ۝ لَمْ يَلِدْ وَلَمْ يُولَدْ ۝ وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ\n\n'
          'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ\n'
          'قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ ۝ مِن شَرِّ مَا خَلَقَ ۝ وَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ ۝ وَمِن شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ ۝ وَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ\n\n'
          'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ\n'
          'قُلْ أَعُوذُ بِرَبِّ النَّاسِ ۝ مَلِكِ النَّاسِ ۝ إِلَٰهِ النَّاسِ ۝ مِن شَرِّ الْوَسْوَاسِ الْخَنَّاسِ ۝ الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ ۝ مِنَ الْجِنَّةِ وَالنَّاسِ',
      transliteration:
          'Bismillaahir-Rahmaanir-Raheem.\n'
          'Qul huwal-laahu ahad. Allaahus-samad. Lam yalid wa lam yoolad. Wa lam yakul-lahoo kufuwan ahad.\n\n'
          'Bismillaahir-Rahmaanir-Raheem.\n'
          'Qul a\'oodhu bi-rabbil-falaq. Min sharri maa khalaq. Wa min sharri ghaasiqin idhaa waqab. Wa min sharrin-naffaathaati fil-\'uqad. Wa min sharri haasidin idhaa hasad.\n\n'
          'Bismillaahir-Rahmaanir-Raheem.\n'
          'Qul a\'oodhu bi-rabbin-naas. Malikin-naas. Ilaahin-naas. Min sharril-waswaasil-khannaas. Alladhee yuwaswisu fee sudoorin-naas. Minal-jinnati wan-naas.',
      translation:
          'In the name of Allah, the Entirely Merciful, the Especially Merciful.\n'
          'Say, "He is Allah, [who is] One, Allah, the Eternal Refuge. He neither begets nor is born, Nor is there to Him any equivalent."\n\n'
          'In the name of Allah, the Entirely Merciful, the Especially Merciful.\n'
          'Say, "I seek refuge in the Lord of daybreak From the evil of that which He created And from the evil of darkness when it settles And from the evil of the blowers in knots And from the evil of an envier when he envies."\n\n'
          'In the name of Allah, the Entirely Merciful, the Especially Merciful.\n'
          'Say, "I seek refuge in the Lord of mankind, The Sovereign of mankind. The God of mankind, From the evil of the retreating whisperer - Who whispers [evil] into the breasts of mankind - From among the jinn and mankind."',
      reference: 'Surah Al-Ikhlas (112), Al-Falaq (113), An-Nas (114); Al-Bukhari 5017, Abu Dawud 5056, At-Tirmidhi 3402',
      targetCount: 3,
      audioUrl: 'assets/audio/before_sleeping_1.mp3',
    ),
    // 2. Ayatul Kursi (Hisn al-Muslim #100)
    AzkarItem(
      arabic: 'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ ۚ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ ۚ لَّهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ ۗ مَن ذَا الَّذِي يَشْفَعُ عِندَهُ إِلَّا بِإِذْنِهِ ۚ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ ۖ وَلَا يُحِيطُونَ بِشَيْءٍ مِّنْ عِلْمِهِ إِلَّا بِمَا شَاءَ ۚ وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضَ ۖ وَلَا يَئُودُهُ حِفْظُهُمَا ۚ وَهُوَ الْعَلِيُّ الْعَظِيمُ',
      transliteration: 'Allaahu laa ilaaha illaa Huwal-Hayyul-Qayyoom, laa ta\'khudhuhu sinatun wa laa nawm, lahu maa fis-samaawaati wa maa fil-ard, man dhal-ladhee yashfa\'u \'indahu illaa bi-idhnih, ya\'lamu maa bayna aydeehim wa maa khalfahum, wa laa yuheetoona bi-shay\'in min \'ilmihi illaa bimaa shaa\', wasi\'a kursiyyuhus-samaawaati wal-ard, wa laa ya\'ooduhu hifdhuhumaa, wa Huwal-\'Aliyyul-\'Adheem.',
      translation: 'Allah - there is no deity except Him, the Ever-Living, the Sustainer of [all] existence. Neither drowsiness overtakes Him nor sleep. To Him belongs whatever is in the heavens and whatever is on the earth. Who is it that can intercede with Him except by His permission? He knows what is [presently] before them and what will be after them, and they encompass not a thing of His knowledge except for what He wills. His Kursi extends over the heavens and the earth, and their preservation tires Him not. And He is the Most High, the Most Great.',
      reference: 'Surah Al-Baqarah 2:255, Al-Bukhari 2311',
      targetCount: 1,
      audioUrl: 'assets/audio/before_sleeping_2.mp3',
    ),
    // 3. Last two verses of Al-Baqarah (Hisn al-Muslim #101)
    AzkarItem(
      arabic: 'آمَنَ الرَّسُولُ بِمَا أُنزِلَ إِلَيْهِ مِن رَّبِّهِ وَالْمُؤْمِنُونَ ۚ كُلٌّ آمَنَ بِاللَّهِ وَمَلَائِكَتِهِ وَكُتُبِهِ وَرُسُلِهِ لَا نُفَرِّقُ بَيْنَ أَحَدٍ مِّن رُّسُلِهِ ۚ وَقَالُوا سَمِعْنَا وَأَطَعْنَا ۖ غُفْرَانَكَ رَبَّنَا وَإِلَيْكَ الْمَصِيرُ ۝ لَا يُكَلِّفُ اللَّهُ نَفْسًا إِلَّا وُسْعَهَا ۚ لَهَا مَا كَسَبَتْ وَعَلَيْهَا مَا اكْتَسَبَتْ ۗ رَبَّنَا لَا تُؤَاخِذْنَا إِن نَّسِينَا أَوْ أَخْطَأْنَا ۚ رَبَّنَا وَلَا تَحْمِلْ عَلَيْنَا إِصْرًا كَمَا حَمَلْتَهُ عَلَى الَّذِينَ مِن قَبْلِنَا ۚ رَبَّنَا وَلَا تُحَمِّلْنَا مَا لَا طَاقَةَ لَنَا بِهِ ۖ وَاعْفُ عَنَّا وَاغْفِرْ لَنَا وَارْحَمْنَا ۚ أَنتَ مَوْلَانَا فَانصُرْنَا عَلَى الْقَوْمِ الْكَافِرِينَ',
      transliteration: 'Aamanar-Rasoolu bimaa unzila ilayhi mir-Rabbihi wal-mu\'minoon, kullun aamana billaahi wa malaa\'ikatihi wa kutubihi wa rusulih, laa nufarriqu bayna ahadin mir-rusulih, wa qaaloo sami\'naa wa ata\'naa ghufraanaka Rabbanaa wa ilaykal-maseer. Laa yukalliful-laahu nafsan illaa wus\'ahaa, lahaa maa kasabat wa \'alayhaa maktasabat, Rabbanaa laa tu\'aakhidhnaa in naseenaa aw akhta\'naa, Rabbanaa wa laa tahmil \'alaynaa isran kamaa hamaltahu \'alal-ladheena min qablinaa, Rabbanaa wa laa tuhammilnaa maa laa taaqata lanaa bih, wa\'fu \'annaa waghfir lanaa warhamnaa, Anta Mawlaanaa fansurnaa \'alal-qawmil-kaafireen.',
      translation: 'The Messenger has believed in what was revealed to him from his Lord, and [so have] the believers. All of them have believed in Allah and His angels and His books and His messengers, [saying], "We make no distinction between any of His messengers." And they say, "We hear and we obey. [We seek] Your forgiveness, our Lord, and to You is the [final] destination." Allah does not charge a soul except [with that within] its capacity. It will have [the consequence of] what [good] it has gained, and it will bear [the consequence of] what [evil] it has earned. "Our Lord, do not impose blame upon us if we have forgotten or erred. Our Lord, and lay not upon us a burden like that which You laid upon those before us. Our Lord, and burden us not with that which we have no ability to bear. And pardon us; and forgive us; and have mercy upon us. You are our protector, so give us victory over the disbelieving people."',
      reference: 'Surah Al-Baqarah 2:285-286, Al-Bukhari 4008, Muslim 807',
      targetCount: 1,
      audioUrl: 'assets/audio/before_sleeping_3.mp3',
    ),
    // 4. Bismika rabbee wada'tu janbee (Hisn al-Muslim #102)
    AzkarItem(
      arabic: 'بِاسْمِكَ رَبِّي وَضَعْتُ جَنْبِي، وَبِكَ أَرْفَعُهُ، فَإِنْ أَمْسَكْتَ نَفْسِي فَارْحَمْهَا، وَإِنْ أَرْسَلْتَهَا فَاحْفَظْهَا بِمَا تَحْفَظُ بِهِ عِبَادَكَ الصَّالِحِينَ.',
      transliteration: 'Bismika Rabbee wada\'tu janbee wa bika arfa\'uh, fa in amsakta nafsee farhamhaa, wa in arsaltahaa fahfadhhaa bimaa tahfadhu bihi \'ibaadakas-saaliheen.',
      translation: 'In Your Name my Lord, I lie down and in Your Name I rise, so if You should take my soul then have mercy upon it, and if You should return my soul then protect it in the manner You do so with Your righteous servants.',
      reference: 'Al-Bukhari 6320, Muslim 2714',
      targetCount: 1,
      audioUrl: 'assets/audio/before_sleeping_4.mp3',
    ),
    // 5. Allaahumma innaka khalaqta nafsee (Hisn al-Muslim #103)
    AzkarItem(
      arabic: 'اللَّهُمَّ إِنَّكَ خَلَقْتَ نَفْسِي وَأَنْتَ تَوَفَّاهَا، لَكَ مَمَاتُهَا وَمَحْيَاهَا، إِنْ أَحْيَيْتَهَا فَاحْفَظْهَا، وَإِنْ أَمَتَّهَا فَاغْفِرْ لَهَا، اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَافِيَةَ.',
      transliteration: 'Allaahumma innaka khalaqta nafsee wa Anta tawaffaahaa, laka mamaatuhaa wa mahyaahaa, in ahyaytahaa fahfadhhaa, wa in amattahaa faghfir lahaa, Allaahumma innee as\'alukal-\'aafiyah.',
      translation: 'O Allah, You have created my soul and You take it back, unto You is its death and its life. If You give it life then protect it, and if You cause it to die then forgive it. O Allah, I ask You to grant it salvation.',
      reference: 'Muslim 2712, Ahmad 2:79',
      targetCount: 1,
      audioUrl: 'assets/audio/before_sleeping_5.mp3',
    ),
    // 6. Allaahumma qinee 'adhaabaka (Hisn al-Muslim #104)
    AzkarItem(
      arabic: 'اللَّهُمَّ قِنِي عَذَابَكَ يَوْمَ تَبْعَثُ عِبَادَكَ.',
      transliteration:
          'Allaahumma qinee \'adhaabaka yawma tab\'athu \'ibaadak.',
      translation: 'O Allah, protect me from Your punishment on the Day that You resurrect Your servants.',
      reference: 'Abu Dawud 5045, At-Tirmidhi 3398',
      targetCount: 3,
      audioUrl: 'assets/audio/before_sleeping_6.mp3',
    ),
    // 7. Bismika Allaahumma amootu wa ahyaa (Hisn al-Muslim #105)
    AzkarItem(
      arabic: 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا.',
      transliteration: 'Bismika Allaahumma amootu wa ahyaa.',
      translation: 'In Your Name, O Allah, I die and I live.',
      reference: 'Al-Bukhari 6324, Muslim 2711',
      targetCount: 1,
      audioUrl: 'assets/audio/before_sleeping_7.mp3',
    ),
    // 8. Tasbeeh (Hisn al-Muslim #106)
    AzkarItem(
      arabic: 'سُبْحَانَ اللَّهِ (ثَلَاثًا وَثَلَاثِينَ) الْحَمْدُ لِلَّهِ (ثَلَاثًا وَثَلَاثِينَ) اللَّهُ أَكْبَرُ (أَرْبَعًا وَثَلَاثِينَ)',
      transliteration:
          'Subhaanallaah (33)\nAlhamdulillaah (33)\nAllaahu Akbar (34)',
      translation: 'How far from imperfections Allah is. (33) All praise is for Allah. (33) Allah is the greatest. (34)',
      reference: 'Al-Bukhari 3705, Muslim 2727',
      targetCount: 100,
      audioUrl: 'assets/audio/before_sleeping_8.mp3',
    ),
    // 9. Allaahumma Rabbas-samaawaatis-sab'i (Hisn al-Muslim #107)
    AzkarItem(
      arabic: 'اللَّهُمَّ رَبَّ السَّمَاوَاتِ السَّبْعِ وَرَبَّ الْأَرْضِ، وَرَبَّ الْعَرْشِ الْعَظِيمِ، رَبَّنَا وَرَبَّ كُلِّ شَيْءٍ، فَالِقَ الْحَبِّ وَالنَّوَى، وَمُنْزِلَ التَّوْرَاةِ وَالْإِنْجِيلِ وَالْفُرْقَانِ، أَعُوذُ بِكَ مِنْ شَرِّ كُلِّ شَيْءٍ أَنْتَ آخِذٌ بِنَاصِيَتِهِ، اللَّهُمَّ أَنْتَ الْأَوَّلُ فَلَيْسَ قَبْلَكَ شَيْءٌ، وَأَنْتَ الْآخِرُ فَلَيْسَ بَعْدَكَ شَيْءٌ، وَأَنْتَ الظَّاهِرُ فَلَيْسَ فَوْقَكَ شَيْءٌ، وَأَنْتَ الْبَاطِنُ فَلَيْسَ دُونَكَ شَيْءٌ، اقْضِ عَنَّا الدَّيْنَ وَأَغْنِنَا مِنَ الْفَقْرِ.',
      transliteration: 'Allaahumma Rabbas-samaawaatis-sab\'i wa Rabbal-ard, wa Rabbal-\'Arshil-\'Adheem, Rabbanaa wa Rabba kulli shay\', faaliqal-habbi wan-nawaa, wa munzilat-Tawraati wal-Injeeli wal-Furqaan, a\'oodhu bika min sharri kulli shay\'in Anta aakhidhun bi-naasiyatih. Allaahumma Antal-Awwalu fa-laysa qablaka shay\', wa Antal-Aakhiru fa-laysa ba\'daka shay\', wa Antadh-Dhaahiru fa-laysa fawqaka shay\', wa Antal-Baatinu fa-laysa doonaka shay\', iqdi \'annad-dayna wa aghninaa minal-faqr.',
      translation: 'O Allah, Lord of the seven heavens and Lord of the earth, and Lord of the Magnificent Throne, our Lord and Lord of everything, Splitter of the seed and the date-stone, Revealer of the Torah, the Gospel, and the Criterion (Quran), I seek refuge in You from the evil of everything that You shall seize by the forelock. O Allah, You are the First so there is nothing before You, and You are the Last so there is nothing after You. You are the Apparent so there is nothing above You, and You are the Unapparent so there is nothing closer than You. Settle our debt for us and spare us from poverty.',
      reference: 'Muslim 2713, At-Tirmidhi 3400, Ibn Majah 3831',
      targetCount: 1,
      audioUrl: 'assets/audio/before_sleeping_9.mp3',
    ),
    // 10. Alhamdulillaahil-ladhee at'amanaa wa saqaanaa (Hisn al-Muslim #108)
    AzkarItem(
      arabic: 'الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنَا وَسَقَانَا، وَكَفَانَا، وَآوَانَا، فَكَمْ مِمَّنْ لَا كَافِيَ لَهُ وَلَا مُؤْوِيَ.',
      transliteration: 'Alhamdulillaahil-ladhee at\'amanaa wa saqaanaa, wa kafaanaa, wa aawaanaa, fakam mimman laa kaafiya lahu wa laa mu\'wee.',
      translation: 'All praise is for Allah, Who fed us and gave us to drink, and Who is sufficient for us and has sheltered us, for how many have none to suffice them or shelter them.',
      reference: 'Muslim 2715',
      targetCount: 1,
      // Audio 10 specifically matches the text "Alhamdulillaahil-ladhee at'amanaa wa saqaanaa"
      audioUrl: 'assets/audio/before_sleeping_10.mp3',
    ),
    // 11. Allaahumma 'Aalimal-ghaybi wash-shahaadah (Hisn al-Muslim #109)
    AzkarItem(
      arabic: 'اللَّهُمَّ عَالِمَ الْغَيْبِ وَالشَّهَادَةِ فَاطِرَ السَّمَاوَاتِ وَالْأَرْضِ، رَبَّ كُلِّ شَيْءٍ وَمَلِيكَهُ، أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا أَنْتَ، أَعُوذُ بِكَ مِنْ شَرِّ نَفْسِي، وَمِنْ شَرِّ الشَّيْطَانِ وَشِرْكِهِ، وَأَنْ أَقْتَرِفَ عَلَى نَفْسِي سُوءًا، أَوْ أَجُرَّهُ إِلَى مُسْلِمٍ.',
      transliteration: 'Allaahumma \'Aalimal-ghaybi wash-shahaadati faatiras-samaawaati wal-ard, Rabba kulli shay\'in wa maleekah, ash-hadu an laa ilaaha illaa Ant, a\'oodhu bika min sharri nafsee, wa min sharrish-shaytaani wa shirkih, wa an aqtarifa \'alaa nafsee soo\'an, aw ajurrahu ilaa Muslim.',
      translation: 'O Allah, Knower of the unseen and the evident, Maker of the heavens and the earth, Lord of everything and its Master, I bear witness that there is none worthy of worship but You. I seek refuge in You from the evil of my soul and from the evil of Shaytan and his helpers, and from bringing evil upon myself or harming any Muslim.',
      reference: 'Abu Dawud 5067, At-Tirmidhi 3392',
      targetCount: 1,
      audioUrl: 'assets/audio/before_sleeping_11.mp3',
    ),
    // 12. Allaahumma aslamtu nafsee ilayk (Hisn al-Muslim #110)
    // Audio 13 specifically matches the text "Allahumma aslamtu..."
    AzkarItem(
      arabic: 'اللَّهُمَّ أَسْلَمْتُ نَفْسِي إِلَيْكَ، وَفَوَّضْتُ أَمْرِي إِلَيْكَ، وَوَجَّهْتُ وَجْهِي إِلَيْكَ، وَأَلْجَأْتُ ظَهْرِي إِلَيْكَ، رَغْبَةً وَرَهْبَةً إِلَيْكَ، لَا مَلْجَأَ وَلَا مَنْجَا مِنْكَ إِلَّا إِلَيْكَ، آمَنْتُ بِكِتَابِكَ الَّذِي أَنْزَلْتَ، وَبِنَبِيِّكَ الَّذِي أَرْسَلْتَ.',
      transliteration: 'Allaahumma aslamtu nafsee ilayk, wa fawwadtu amree ilayk, wa wajjahtu wajhee ilayk, wa alja\'tu dhahree ilayk, raghbatan wa rahbatan ilayk, laa malja\'a wa laa manjaa minka illaa ilayk, aamantu bi-kitaabikal-ladhee anzalt, wa bi-nabiyyikal-ladhee arsalt.',
      translation: 'O Allah, I submit myself to You, entrust my affairs to You, turn my face to You, and lay myself down depending upon You, hoping in You and fearing You. There is no refuge, and no escape, except to You. I believe in Your Book (the Quran) that You revealed, and the Prophet whom You sent.',
      reference: 'Al-Bukhari 6311, Muslim 2710',
      targetCount: 1,
      audioUrl: 'assets/audio/before_sleeping_13.mp3',
    ),
    // 13. Reciting Surah As-Sajdah & Surah Al-Mulk (Hisn al-Muslim #111)
    // Audio 12 specifically contains the recitations of these Surahs
    AzkarItem(
      arabic: 'يَقْرَأُ: ﴿الم ۝ تَنزِيلُ الْكِتَابِ...﴾ [السجدة]، وَ ﴿تَبَارَكَ الَّذِي بِيَدِهِ الْمُلْكُ...﴾ [الملك].',
      transliteration: 'Yaqra\'u: "Alif-Laam-Meem. Tanzeelul-Kitaabi..." [Surah As-Sajdah (32)] wa "Tabaarakal-ladhee bi-yadihil-Mulk..." [Surah Al-Mulk (67)].',
      translation: 'Recite Surah As-Sajdah (Chapter 32) and Surah Al-Mulk (Chapter 67) before going to sleep.',
      reference: 'At-Tirmidhi 3404, An-Nasa\'i in Amalul-Yawmi wal-Laylah 707',
      targetCount: 1,
      audioUrl: 'assets/audio/before_sleeping_12.mp3',
    ),
  ];

  // --- WAKING UP AZKAR ---
  static final List<AzkarItem> wakingUp = [
    // 1. Alhamdu lillahil-ladhee ahyaanaa
    AzkarItem(
      arabic: 'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ.',
      transliteration: 'Alhamdu lillaahil-ladhee ahyaanaa ba\'da maa amaatanaa wa ilayhin-nushoor.',
      translation: 'All praise is for Allah who gave us life after having taken it from us and unto Him is the resurrection.',
      reference: 'Al-Bukhari 11:113, Muslim 4:2083',
      targetCount: 1,
      audioUrl: 'assets/audio/waking_up_1.mp3',
    ),
    // 2. Laa ilaaha illallaahu wahdahu
    AzkarItem(
      arabic: 'لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَاشَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ، وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ، سُبْحَانَ اللَّهِ، وَالْحَمْدُ لِلَّهِ، وَلَا إِلَهَ إِلَّا اللَّهُ وَاللَّهُ أَكْبَرُ وَلَاحَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ الْعَلِيِّ الْعَظِيمِ، رَبِّ اغْفِرْ لِي.',
      transliteration: 'Laa ilaaha illallaahu wahdahu laa shareeka lahu, lahul-mulku wa lahul-hamdu, wa Huwa \'alaa kulli shay\'in Qadeer. Subhaanallaahi, walhamdu lillaahi, wa laa ilaaha illallaahu, wallaahu akbar, wa laa hawla wa laa quwwata illaa billaahil-\'Aliyyil-\'Adheem. Rabbighfir lee.',
      translation: 'There is none worthy of worship in truth except Allah alone, without partner. To Him belongs all sovereignty and praise, and He is over all things omnipotent. How far from imperfections Allah is, and all praise is for Allah, and there is none worthy of worship in truth except Allah, and Allah is the greatest, and there is no might and no power except with Allah, the Most High, the Most Great. O my Lord, forgive me.',
      reference: 'Al-Bukhari 3:144',
      targetCount: 1,
      audioUrl: 'assets/audio/waking_up_2.mp3',
    ),
    // 3. Alhamdu lillahil-ladhee 'aafaanee
    AzkarItem(
      arabic: 'الْحَمْدُ لِلَّهِ الَّذِي عَافَانِي فِي جَسَدِي وَرَدَّ عَلَيَّ رُوحِي وَأَذِنَ لِي بِذِكْرِهِ.',
      transliteration: 'Alhamdu lillaahil-ladhee \'aafaanee fee jasadee, wa radda \'alayya roohee, wa adhina lee bi-dhikrih.',
      translation: 'All praise is for Allah who restored to me my health and returned my soul and has allowed me to remember Him.',
      reference: 'At-Tirmidhi 5:473',
      targetCount: 1,
      audioUrl: 'assets/audio/waking_up_3.mp3',
    ),
    // 4. Surah Al 'Imran 190-200
    AzkarItem(
      arabic: 'إِنَّ فِي خَلْقِ السَّمَاوَاتِ وَالْأَرْضِ وَاخْتِلَافِ اللَّيْلِ وَالنَّهَارِ لَآيَاتٍ لِّأُولِي الْأَلْبَابِ ۝ الَّذِينَ يَذْكُرُونَ اللَّهَ قِيَامًا وَقُعُودًا وَعَلَىٰ جُنُوبِهِمْ وَيَتَفَكَّرُونَ فِي خَلْقِ السَّمَاوَاتِ وَالْأَرْضِ رَبَّنَا مَا خَلَقْتَ هَٰذَا بَاطِلًا سُبْحَانَكَ فَقِنَا عَذَابَ النَّارِ ۝ رَبَّنَا إِنَّكَ مَن تُدْخِلِ النَّارَ فَقَدْ أَخْزَيْتَهُ ۖ وَمَا لِلظَّالِمِينَ مِنْ أَنصَارٍ ۝ رَّبَّنَا إِنَّنَا سَمِعْنَا مُنَادِيًا يُنَادِي لِلْإِيمَانِ أَنْ آمِنُوا بِرَبِّكُمْ فَآمَنَّا ۚ رَبَّنَا فَاغْفِرْ لَنَا ذُنُوبَنَا وَكَفِّرْ عَنَّا سَيِّئَاتِنَا وَتَوَفَّنَا مَعَ الْأَبْرَارِ ۝ رَبَّنَا وَآتِنَا مَا وَعَدتَّنَا عَلَىٰ رُسُلِكَ وَلَا تُخْزِنَا يَوْمَ الْقِيَامَةِ ۗ إِنَّكَ لَا تُخْلِفُ الْمِيعَادَ ۝ فَاسْتَجَابَ لَهُمْ رَبُّهُمْ أَنِّي لَا أُضِيعُ عَمَلَ عَامِلٍ مِّنكُم مِّن ذَكَرٍ أَوْ أُنثَىٰ ۖ بَعْضُكُم مِّن بَعْضٍ ۖ فَالَّذِينَ هَاجَرُوا وَأُخْرِجُوا مِن دِيَارِهِمْ وَأُوذُوا فِي سَبِيلِي وَقَاتَلُوا وَقُتِلُوا لَأُكَفِّرَنَّ عَنْهُمْ سَيِّئَاتِهِمْ وَلَأُدْخِلَنَّهُمْ جَنَّاتٍ تَجْرِي مِن تَحْتِهَا الْأَنْهَارُ ثَوَابًا مِّنْ عِندِ اللَّهِ ۗ وَاللَّهُ عِندَهُ حُسْنُ الثَّوَابِ ۝ لَا يَغُرَّنَّكَ تَقَلُّبُ الَّذِينَ كَفَرُوا فِي الْبِلَادِ ۝ مَتَاعٌ قَلِيلٌ ثُمَّ مَأْوَاهُمْ جَهَنَّمُ ۚ وَبِئْسَ الْمِهَادُ ۝ لَٰكِنِ الَّذِينَ اتَّقَوْا رَبَّهُمْ لَهُمْ جَنَّاتٌ تَجْرِي مِن تَحْتِهَا الْأَنْهَارُ خَالِدِينَ فِيهَا نُزُلًا مِّنْ عِندِ اللَّهِ ۗ وَمَا عِندَ اللَّهِ خَيْرٌ لِّلْأَبْرَارِ ۝ وَإِنَّ مِنْ أَهْلِ الْكِتَابِ لَمَن يُؤْمِنُ بِاللَّهِ وَمَا أُنزِلَ إِلَيْكُمْ وَمَا أُنزِلَ إِلَيْهِمْ خَاشِعِينَ لِلَّهِ لَا يَشْتَرُونَ بِآيَاتِ اللَّهِ ثَمَنًا قَلِيلًا ۗ أُولَٰئِكَ لَهُمْ أَجْرُهُمْ عِندَ رَبِّهِمْ ۗ إِنَّ اللَّهَ سَرِيعُ الْحِسَابِ ۝ يَا أَيُّهَا الَّذِينَ آمَنُوا اصْبِرُوا وَصَابِرُوا وَرَابِطُوا وَاتَّقُوا اللَّهَ لَعَلَّكُمْ تُفْلِحُونَ',
      transliteration: 'Inna fee khalqis-samaawaati wal-ardi wakhtilaafil-layli wan-nahaari la-aayaatil-li-ulil-albaab. Alladheena yadhkuroonal-laaha qiyaaman wa qu\'oodan wa \'alaa junoobihim wa yatafakkaroona fee khalqis-samaawaati wal-ardi Rabbanaa maa khalaqta haadhaa baatilan subhaanaka faqinaa \'adhaaban-naar. Rabbanaa innaka man tudkhilin-naara faqad akhzaytah, wa maa lidh-dhaalimeena min ansaar. Rabbanaa innanaa sami\'naa munaadiyan yunaadee lil-eemaani an aaminoo bi-Rabbikum fa-aamannaa, Rabbanaa faghfir lanaa dhunoobanaa wa kaffir \'annaa sayyi\'aatinaa wa tawaffanaa ma\'al-abraar. Rabbanaa wa aatinaa maa wa\'attanaa \'alaa rusulika wa laa tukhzinaa yawmal-qiyaamah, innaka laa tukhliful-mee\'aad. Fastajaaba lahum Rabbuhum annee laa udee\'u \'amala \'aamilin minkum min dhakarin aw unthaa ba\'dukum min ba\'d, falladheena haajaroo wa ukhrijoo min diyaarihim wa oodhoo fee sabeelee wa qaataloo wa qutiloo la-ukaffiranna \'anhum sayyi\'aatihim wa la-udkhilannahum jannaatin tajree min tahtihal-anhaaru thawaaban min \'indillaah, wallaahu \'indahu husnuth-thawaab. Laa yaghurrannaka taqallubul-ladheena kafaroo fil-bilaad. Mataa\'un qaleelun thumma ma\'waahum jahannam, wa bi\'sal-mihaad. Laakinil-ladheenat-taqaw Rabbahum lahum jannaatun tajree min tahtihal-anhaaru khaalideena feehaa nuzulan min \'indillaah, wa maa \'indallaahi khayrun lil-abraar. Wa inna min ahlil-kitaabi laman yu\'minu billaahi wa maa unzila ilaykum wa maa unzila ilayhim khaashi\'eena lillaahi laa yashtaroona bi-aayaatillaahi thamanan qaleelaa, ulaa\'ika lahum ajruhum \'inda Rabbihim, innallaaha saree\'ul-hisaab. Yaa ayyuhal-ladheena aamanus-biroo wa saabiroo wa raabitoo wattaqullaaha la\'allakum tuflihoon.',
      translation: 'Indeed, in the creation of the heavens and the earth and the alternation of the night and the day are signs for those of understanding. Who remember Allah while standing or sitting or [lying] on their sides and give thought to the creation of the heavens and the earth, [saying], "Our Lord, You did not create this aimlessly; exalted are You [above such a thing]; then protect us from the punishment of the Fire. Our Lord, indeed whoever You admit to the Fire - You have disgraced him, and for the wrongdoers there are no helpers. Our Lord, indeed we have heard a caller calling to faith, [saying], \'Believe in your Lord,\' and we have believed. Our Lord, so forgive us our sins and remove from us our misdeeds and cause us to die with the righteous. Our Lord, and grant us what You promised us through Your messengers and do not disgrace us on the Day of Resurrection. Indeed, You do not fail in [Your] promise." And their Lord responded to them, "Never will I allow to be lost the work of [any] worker among you, whether male or female; you are of one another. So those who emigrated or were evicted from their homes or were harmed in My cause or fought or were killed - I will surely remove from them their misdeeds, and I will surely admit them to gardens beneath which rivers flow as reward from Allah, and Allah has with Him the best reward." Be not deceived by the [uninhibited] movement of the disbelievers throughout the land. [It is but] a small enjoyment; then their [final] refuge is Hell, and wretched is the resting place. But those who feared their Lord will have gardens beneath which rivers flow, abiding eternally therein, as accommodation from Allah. And that which is with Allah is best for the righteous. And indeed, among the People of the Scripture are those who believe in Allah and what was revealed to you and what was revealed to them, [being] humbly submissive to Allah. They do not exchange the verses of Allah for a small price. Those will have their reward with their Lord. Indeed, Allah is swift in account. O you who have believed, persevere and endure and remain stationed and fear Allah that you may be successful.',
      reference: 'Surah Al \'Imran 3:190-200, Al-Bukhari 4569',
      targetCount: 1,
      audioUrl: 'assets/audio/waking_up_4.mp3',
    ),
  ];

  // --- AFTER PRAYER AZKAR (HISN AL-MUSLIM CH. 25) ---
  static final List<AzkarItem> afterPrayer = [
    // 1. Astaghfirullaah & Allaahumma Antas-Salaam
    AzkarItem(
      arabic: 'أَسْتَغْفِرُ اللَّهَ. (ثَلَاثًا)\nاللَّهُمَّ أَنْتَ السَّلَامُ وَمِنْكَ السَّلَامُ تَبَارَكْتَ يَا ذَا الْجَلَالِ وَالْإِكْرَامِ.',
      transliteration: 'Astaghfirullaah (3 times).\nAllaahumma Antas-Salaam wa minkas-salaam, tabaarakta yaa Dhal-Jalaali wal-Ikraam.',
      translation: '\'I ask Allah for forgiveness.\' [three times]\n\'O Allah, You are as-Salam and from You is all peace, blessed are You, O Possessor of majesty and honour.\'',
      reference: 'Muslim 1/414',
      targetCount: 1,
      audioUrl: 'assets/audio/after_prayer_1.mp3',
    ),
    // 2. Laa ilaaha illallaahu... laa maani'a
    AzkarItem(
      arabic: 'لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ، اللَّهُمَّ لَا مَانِعَ لِمَا أَعْطَيْتَ، وَلَا مُعْطِيَ لِمَا مَنَعْتَ، وَلَا يَنْفَعُ ذَا الْجَدِّ مِنْكَ الْجَدِّ.',
      transliteration: 'Laa ilaaha illallaahu wahdahu laa shareeka lahu, lahul-mulku wa lahul-hamdu wa Huwa \'alaa kulli shay\'in qadeer, Allaahumma laa maani\'a limaa a\'tayta, wa laa mu\'tiya limaa mana\'ta, wa laa yanfa\'u dhal-jaddi minkal-jadd.',
      translation: '\'None has the right to be worshipped except Allah, alone, without any partner, to Him belong all sovereignty and praise and He is over all things omnipotent. O Allah, none can prevent what You have willed to bestow and none can bestow what You have willed to prevent, and no wealth or majesty can benefit anyone, as from You is all wealth and majesty.\'',
      reference: 'Al-Bukhari 1/255, Muslim 1/414',
      targetCount: 1,
      audioUrl: 'assets/audio/after_prayer_2.mp3',
    ),
    // 3. Laa ilaaha illallaahu... laa hawla
    AzkarItem(
      arabic: 'لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ. لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ، لَا إِلَهَ إِلَّا اللَّهُ، وَلَا نَعْبُدُ إِلَّا إِيَّاهُ، لَهُ النِّعْمَةُ وَلَهُ الْفَضْلُ وَلَهُ الثَّنَاءُ الْحَسَنُ، لَا إِلَهَ إِلَّا اللَّهُ مُخْلِصِينَ لَهُ الدِّينَ وَلَوْ كَرِهَ الْكَافِرُونَ.',
      transliteration: 'Laa ilaaha illallaahu wahdahu la shareeka lahu, lahul-mulku wa lahul-hamdu wa Huwa \'alaa kulli shay\'in qadeer. Laa hawla wa laa quwwata illaa billaah, laa ilaaha illallaahu, wa laa na\'budu illaa iyyaahu, lahun-ni\'matu wa lahul-fadlu wa lahuth-thanaa\'ul-hasan, laa ilaaha illallaahu mukhliseena lahud-deena wa law karihal-kaafiroon.',
      translation: '\'None has the right to be worshipped except Allah, alone, without any partner, to Him belong all sovereignty and praise and He is over all things omnipotent. There is no might nor power except with Allah, none has the right to be worshipped except Allah and we worship none except Him. For Him is all favour, grace, and glorious praise. None has the right to be worshipped except Allah and we are sincere in faith and devotion to Him although the disbelievers detest it.\'',
      reference: 'Muslim 1/415',
      targetCount: 1,
      audioUrl: 'assets/audio/after_prayer_3.mp3',
    ),
    // 4. Tasbeeh & Completion
    AzkarItem(
      arabic: 'سُبْحَانَ اللَّهِ، وَالْحَمْدُ لِلَّهِ، وَاللَّهُ أَكْبَرُ. (ثَلَاثًا وَثَلَاثِينَ)\nلَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ.',
      transliteration: 'Subhaanallaahi, wal-hamdu lillaahi wallaahu akbar. [33 times]\nLaa ilaaha illallaahu wahdahu la shareeka lahu, lahul-mulku wa lahul-hamdu wa Huwa \'alaa kulli shay\'in qadeer.',
      translation: '\'How perfect Allah is, all praise is for Allah, and Allah is the greatest.\' [thirty-three times]\n\'None has the right to be worshipped except Allah, alone, without any partner, to Him belong all sovereignty and praise and He is over all things omnipotent.\'',
      reference: 'Muslim 1/418',
      targetCount: 100, // 33 + 33 + 33 + 1
      audioUrl: 'assets/audio/after_prayer_4.mp3',
    ),
    // 5. The 3 Suwar (Quls)
    AzkarItem(
      arabic:
          'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ\n'
          'قُلْ هُوَ اللَّهُ أَحَدٌ ۝ اللَّهُ الصَّمَدُ ۝ لَمْ يَلِدْ وَلَمْ يُولَدْ ۝ وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ\n\n'
          'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ\n'
          'قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ ۝ مِن شَرِّ مَا خَلَقَ ۝ وَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ ۝ وَمِن شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ ۝ وَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ\n\n'
          'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ\n'
          'قُلْ أَعُوذُ بِرَبِّ النَّاسِ ۝ مَلِكِ النَّاسِ ۝ إِلَٰهِ النَّاسِ ۝ مِن شَرِّ الْوَسْوَاسِ الْخَنَّاسِ ۝ الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ ۝ مِنَ الْجِنَّةِ وَالنَّاسِ',
      transliteration:
          'Bismillaahir-Rahmaanir-Raheem.\n'
          'Qul huwal-laahu ahad. Allaahus-samad. Lam yalid wa lam yoolad. Wa lam yakul-lahoo kufuwan ahad.\n\n'
          'Bismillaahir-Rahmaanir-Raheem.\n'
          'Qul a\'oodhu bi-rabbil-falaq. Min sharri maa khalaq. Wa min sharri ghaasiqin idhaa waqab. Wa min sharrin-naffaathaati fil-\'uqad. Wa min sharri haasidin idhaa hasad.\n\n'
          'Bismillaahir-Rahmaanir-Raheem.\n'
          'Qul a\'oodhu bi-rabbin-naas. Malikin-naas. Ilaahin-naas. Min sharril-waswaasil-khannaas. Alladhee yuwaswisu fee sudoorin-naas. Minal-jinnati wan-naas.',
      translation:
          'In the name of Allah, the Entirely Merciful, the Especially Merciful.\n'
          'Say, "He is Allah, [who is] One, Allah, the Eternal Refuge. He neither begets nor is born, Nor is there to Him any equivalent."\n\n'
          'In the name of Allah, the Entirely Merciful, the Especially Merciful.\n'
          'Say, "I seek refuge in the Lord of daybreak From the evil of that which He created And from the evil of darkness when it settles And from the evil of the blowers in knots And from the evil of an envier when he envies."\n\n'
          'In the name of Allah, the Entirely Merciful, the Especially Merciful.\n'
          'Say, "I seek refuge in the Lord of mankind, The Sovereign of mankind. The God of mankind, From the evil of the retreating whisperer - Who whispers [evil] into the breasts of mankind - From among the jinn and mankind."\n'
          '[Once after Zuhr, Asr and Isha prayers and thrice after Fajr and Maghrib]',
      reference: 'Surah Al-Ikhlas (112), Al-Falaq (113), An-Nas (114); Abu Dawud 2/86, An-Nasa\'i 3/68',
      targetCount: 1,
      audioUrl: 'assets/audio/after_prayer_5.mp3',
    ),
    // 6. Ayat al-Kursi
    AzkarItem(
      arabic: 'اللَّهُ لَا إِلَهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ لَّهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ مَن ذَا الَّذِي يَشْفَعُ عِندَهُ إِلَّا بِإِذْنِهِ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ وَلَا يُحِيطُونَ بِشَيْءٍ مِّنْ عِلْمِهِ إِلَّا بِمَا شَاءَ وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضَ وَلَا يَئُودُهُ حِفْظُهُمَا وَهُوَ الْعَلِيُّ الْعَظِيمُ',
      transliteration: 'Allaahu laa ilaaha illaa Huwal-Hayyul-Qayyoom laa ta\'khudhuhu sinatun wa laa nawm, lahu maa fis-samaawaati wa maa fil-ard, man dhal-ladhee yashfa\'u \'indahu illaa bi-idhnih, ya\'lamu maa bayna aydeehim wa maa khalfahum wa laa yuheetoona bishay\'in min \'ilmihi illaa bimaa shaa\', wasi\'a kursiyyuhus-samaawaati wal-ard, wa laa ya\'ooduhu hifdhuhumaa wa Huwal-\'Aliyyul-\'Adheem.',
      translation: 'Allah, none has the right to be worshipped but He, the Ever-Living, the Self-Sustaining and Sustainer of all. No slumber can seize Him, nor sleep. To Him belongs whatever is in the heavens and on earth. Who is he that can intercede with Him except with His Permission? And He knows what will happen to His creatures in this world and in the Hereafter. Nor shall they encompass anything of His Knowledge except that which He wills. His Kursi extends over the heavens and the earth, and He feels no fatigue in guarding and preserving them. And He is the Most High, the Most Great.',
      reference: 'Surah al-Baqarah: 255; An-Nasa\'i',
      targetCount: 1,
      audioUrl: 'assets/audio/after_prayer_6.mp3',
    ),
    // 7. Laa ilaaha illallaahu... yuhyee wa yumeetu (Fajr/Maghrib)
    AzkarItem(
      arabic: 'لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ يُحْيِي وَيُمِيتُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ.',
      transliteration: 'Laa ilaaha illallaahu wahdahu la shareeka lahu, lahul-mulku wa lahul-hamdu yuhyee wa yumeetu wa Huwa \'alaa kulli shay\'in qadeer.',
      translation: '\'None has the right to be worshipped except Allah, alone, without any partner, to Him belong all sovereignty and praise, He gives life and causes death and He is over all things omnipotent.\'\n[Ten times after the maghrib and fajr prayers]',
      reference: 'At-Tirmidhi 5/515, Ahmad 4/227',
      targetCount: 10,
      audioUrl: 'assets/audio/after_prayer_7.mp3',
    ),
    // 8. Allaahumma innee as'aluka (Fajr)
    AzkarItem(
      arabic: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ عِلْمًا نَافِعًا وَرِزْقًا طَيِّبًا، وَعَمَلًا مُتَقَبَّلًا.',
      transliteration: 'Allaahumma innee as\'aluka \'ilman naafi\'an, wa rizqan tayyiban, wa \'amalan mutaqabbalan.',
      translation: '\'O Allah, I ask You for knowledge which is beneficial and sustenance which is good, and deeds which are acceptable.\'\n[To be said after giving salam for the fajr prayer]',
      reference: 'Ibn Majah 1/298',
      targetCount: 1,
      audioUrl: 'assets/audio/after_prayer_8.mp3',
    ),
  ];

  // --- AFTER OPENING TAKBEER (DU'A AL-ISTIFTAH - HISN AL-MUSLIM CH. 16) ---
  static final List<AzkarItem> afterOpeningTakbeer = [
    // 1. Allaahumma baa'id baynee wa bayna khataayaaya (Hisn al-Muslim #27)
    AzkarItem(
      arabic: 'اللَّهُمَّ بَاعِدْ بَيْنِي وَبَيْنَ خَطَايَايَ كَمَا بَاعَدْتَ بَيْنَ الْمَشْرِقِ وَالْمَغْرِبِ، اللَّهُمَّ نَقِّنِي مِنْ خَطَايَايَ كَمَا يُنَقَّى الثَّوْبُ الْأَبْيَضُ مِنَ الدَّنَسِ، اللَّهُمَّ اغْسِلْنِي مِنْ خَطَايَايَ بِالثَّلْجِ وَالْمَاءِ وَالْبَرَدِ.',
      transliteration: 'Allaahumma baa\'id baynee wa bayna khataayaaya kamaa baa\'adta baynal-mashriqi wal-maghrib, Allaahumma naqqinee min khataayaaya kamaa yunaqqath-thawbul-abyadu minad-danas, Allaahummagh-silnee min khataayaaya bith-thalji wal-maa\'i wal-barad.',
      translation: 'O Allah, separate me from my sins as You have separated the East from the West. O Allah, cleanse me of my transgressions as the white garment is cleansed of stains. O Allah, wash away my sins with ice and water and frost.',
      reference: 'Al-Bukhari 1/181, Muslim 1/419',
      targetCount: 1,
      audioUrl: 'assets/audio/opening_takbeer_1.mp3',
    ),
    // 2. Subhaanakallaahumma wa bi-hamdika (Hisn al-Muslim #28)
    AzkarItem(
      arabic: 'سُبْحَانَكَ اللَّهُمَّ وَبِحَمْدِكَ، وَتَبَارَكَ اسْمُكَ، وَتَعَالَى جَدُّكَ، وَلَا إِلَهَ غَيْرُكَ.',
      transliteration: 'Subhaanakallaahumma wa bi-hamdika, wa tabaarakasmuka, wa ta\'aalaa jadduka, wa laa ilaaha ghayruk.',
      translation: 'How perfect You are O Allah, and I praise You. Blessed be Your name, and lofty is Your position and none has the right to be worshipped except You.',
      reference: 'Abu Dawud 1/206, Ibn Majah 1/268, At-Tirmidhi 1/77, An-Nasa\'i 2/132',
      targetCount: 1,
      audioUrl: 'assets/audio/opening_takbeer_2.mp3',
    ),
    // 3. Wajjahtu wajhiya lilladhee fataras-samaawaati wal-ard (Hisn al-Muslim #29)
    AzkarItem(
      arabic: 'وَجَّهْتُ وَجْهِيَ لِلَّذِي فَطَرَ السَّمَاوَاتِ وَالْأَرْضَ حَنِيفًا وَمَا أَنَا مِنَ الْمُشْرِكِينَ، إِنَّ صَلَاتِي، وَنُسُكِي، وَمَحْيَايَ، وَمَمَاتِي لِلَّهِ رَبِّ الْعَالَمِينَ، لَا شَرِيكَ لَهُ وَبِذَلِكَ أُمِرْتُ وَأَنَا مِنَ الْمُسْلِمِينَ. اللَّهُمَّ أَنْتَ الْمَلِكُ لَا إِلَهَ إِلَّا أَنْتَ، أَنْتَ رَبِّي وَأَنَا عَبْدُكَ، ظَلَمْتُ نَفْسِي وَاعْتَرَفْتُ بِذَنْبِي فَاغْفِرْ لِي ذُنُوبِي جَمِيعًا إِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ. وَاهْدِنِي لِأَحْسَنِ الْأَخْلَاقِ لَا يَهْدِي لِأَحْسَنِهَا إِلَّا أَنْتَ، وَاصْرِفْ عَنِّي سَيِّئَهَا لَا يَصْرِفُ عَنِّي سَيِّئَهَا إِلَّا أَنْتَ، لَبَّيْكَ وَسَعْدَيْكَ، وَالْخَيْرُ كُلُّهُ بِيَدَيْكَ، وَالشَّرُّ لَيْسَ إِلَيْكَ، أَنَا بِكَ وَإِلَيْكَ، تَبَارَكْتَ وَتَعَالَيْتَ، أَسْتَغْفِرُكَ وَأَتُوبُ إِلَيْكَ.',
      transliteration: 'Wajjahtu wajhiya lilladhee fataras-samaawaati wal-arda haneefan wa maa ana minal-mushrikeen, inna salaatee, wa nusukee, wa mahyaaya, wa mamaatee lillaahi Rabbil-\'aalameen, laa shareeka lahu wa bi-dhaalika umirtu wa ana minal-muslimeen. Allaahumma Antal-Maliku laa ilaaha illaa Ant, Anta Rabbee wa ana \'abduka, dhalamtu nafsee wa\'taraftu bi-dhanbee faghfir lee dhunoobee jamee\'an innahu laa yaghfirudh-dhunooba illaa Ant. Wahdinee li-ahsanil-akhlaaqi laa yahdee li-ahsanihaa illaa Ant, wasrif \'annee sayyi\'ahaa laa yasrifu \'annee sayyi\'ahaa illaa Ant, labbayka wa sa\'dayk, wal-khayru kulluhu bi-yadayk, wash-sharru laysa ilayk, ana bika wa ilayk, tabaarakta wa ta\'aalayt, astaghfiruka wa atoobu ilayk.',
      translation: 'I have turned my face towards Him Who has created the heavens and the earth, as a monotheist, and I am not of those who associate others with Allah. Verily, my prayer, my sacrifice, my life and my death are for Allah, Lord of the worlds. He has no partner, and with this I have been commanded, and I am of the Muslims. O Allah, You are the King, none has the right to be worshipped except You. You are my Lord and I am Your servant, I have wronged myself and I acknowledge my sin, so forgive me all my sins, for verily none can forgive sins except You. And guide me to the best of character for none can guide to it other than You, and deliver me from the worst of character for none can deliver me from it other than You. Here I am, in answer to Your call, happy to serve You. All good is within Your hands and evil does not stem from You. I exist by Your will and will return to You. Blessed and High are You, I seek Your forgiveness and repent unto You.',
      reference: 'Muslim 1/534',
      targetCount: 1,
      audioUrl: 'assets/audio/opening_takbeer_3.mp3',
    ),
    // 4. Allaahumma Rabba Jibraa'eela wa Meekaa'eela wa Israafeel (Hisn al-Muslim #30)
    AzkarItem(
      arabic: 'اللَّهُمَّ رَبَّ جِبْرَائِيلَ، وَمِيكَائِيلَ، وَإِسْرَافِيلَ، فَاطِرَ السَّمَاوَاتِ وَالْأَرْضِ، عَالِمَ الْغَيْبِ وَالشَّهَادَةِ، أَنْتَ تَحْكُمُ بَيْنَ عِبَادِكَ فِيمَا كَانُوا فِيهِ يَخْتَلِفُونَ. اهْدِنِي لِمَا اخْتُلِفَ فِيهِ مِنَ الْحَقِّ بِإِذْنِكَ إِنَّكَ تَهْدِي مَنْ تَشَاءُ إِلَى صِرَاطٍ مُسْتَقِيمٍ.',
      transliteration: 'Allaahumma Rabba Jibraa\'eela, wa Meekaa\'eela, wa Israafeel, faatiras-samaawaati wal-ard, \'aalimal-ghaybi wash-shahaadah, Anta tahkumu bayna \'ibaadika feemaa kaanoo feehi yakhtalifoon. Ihdinee limakh-tulifa feehi minal-haqqi bi-idhnik innaka tahdee man tashaa\'u ilaa siraatin mustaqeem.',
      translation: 'O Allah, Lord of Jibra\'il, Mika\'il and Israfil, Creator of the heavens and the earth, Knower of the seen and the unseen. You are the arbitrator between Your servants in that which they have disputed. Guide me to the truth by Your leave, in that which they have differed, for verily You guide whom You will to a straight path.',
      reference: 'Muslim 1/534',
      targetCount: 1,
      audioUrl: 'assets/audio/opening_takbeer_4.mp3',
    ),
    // 5. Allaahu Akbar kabeeraa (Hisn al-Muslim #31)
    AzkarItem(
      arabic: 'اللَّهُ أَكْبَرُ كَبِيرًا، اللَّهُ أَكْبَرُ كَبِيرًا، اللَّهُ أَكْبَرُ كَبِيرًا، وَالْحَمْدُ لِلَّهِ كَثِيرًا، وَالْحَمْدُ لِلَّهِ كَثِيرًا، وَالْحَمْدُ لِلَّهِ كَثِيرًا، وَسُبْحَانَ اللَّهِ بُكْرَةً وَأَصِيلًا. (ثَلَاثًا)\nأَعُوذُ بِاللَّهِ مِنَ الشَّيْطَانِ: مِنْ نَفْخِهِ، وَنَفْثِهِ، وَهَمْزِهِ.',
      transliteration: 'Allaahu Akbar kabeeraa, Allaahu Akbar kabeeraa, Allaahu Akbar kabeeraa, wal-hamdu lillaahi katheeraa, wal-hamdu lillaahi katheeraa, wal-hamdu lillaahi katheeraa, wa subhaanallaahi bukratan wa aseelaa. [3 times]\nA\'oodhu billaahi minash-shaytaani: min nafkhihi, wa nafthihi, wa hamzih.',
      translation: 'Allah is Most Great, altogether great. Allah is Most Great, altogether great. Allah is Most Great, altogether great. And all praise is for Allah, abundantly. And all praise is for Allah, abundantly. And all praise is for Allah, abundantly. And how perfect Allah is, in the morning and the evening. [three times]\nI take refuge in Allah from the devil, from his pride, his poetry and his madness.',
      reference: 'Abu Dawud 1/203, Ibn Majah 1/265, Ahmad 4/85',
      targetCount: 1,
      audioUrl: 'assets/audio/opening_takbeer_5.mp3',
    ),
    // 6. Allaahumma lakal-hamdu Anta noorus-samaawaati wal-ard (Hisn al-Muslim #32)
    AzkarItem(
      arabic: 'اللَّهُمَّ لَكَ الْحَمْدُ أَنْتَ نُورُ السَّمَاوَاتِ وَالْأَرْضِ وَمَنْ فِيهِنَّ، وَلَكَ الْحَمْدُ أَنْتَ قَيِّمُ السَّمَاوَاتِ وَالْأَرْضِ وَمَنْ فِيهِنَّ، وَلَكَ الْحَمْدُ أَنْتَ رَبُّ السَّمَاوَاتِ وَالْأَرْضِ وَمَنْ فِيهِنَّ، وَلَكَ الْحَمْدُ لَكَ مُلْكُ السَّمَاوَاتِ وَالْأَرْضِ وَمَنْ فِيهِنَّ، وَلَكَ الْحَمْدُ أَنْتَ مَلِكُ السَّمَاوَاتِ وَالْأَرْضِ، وَلَكَ الْحَمْدُ، أَنْتَ الْحَقُّ، وَوَعْدُكَ الْحَقُّ، وَقَوْلُكَ الْحَقُّ، وَلِقَاؤُكَ الْحَقُّ، وَالْجَنَّةُ حَقٌّ، وَالنَّارُ حَقٌّ، وَالنَّبِيُّونَ حَقٌّ، وَمُحَمَّدٌ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ حَقٌّ، وَالسَّاعَةُ حَقٌّ، اللَّهُمَّ لَكَ أَسْلَمْتُ، وَعَلَيْكَ تَوَكَّلْتُ، وَبِكَ آمَنْتُ، وَإِلَيْكَ أَنَبْتُ، وَبِكَ خَاصَمْتُ، وَإِلَيْكَ حَاكَمْتُ. فَاغْفِرْ لِي مَا قَدَّمْتُ وَمَا أَخَّرْتُ، وَمَا أَسْرَرْتُ وَمَا أَعْلَنْتُ، أَنْتَ الْمُقَدِّمُ وَأَنْتَ الْمُؤَخِّرُ لَا إِلَهَ إِلَّا أَنْتَ أَنْتَ إِلَهِي لَا إِلَهَ إِلَّا أَنْتَ.',
      transliteration: 'Allaahumma lakal-hamdu Anta noorus-samaawaati wal-ardi wa man feehinna, wa lakal-hamdu Anta qayyimus-samaawaati wal-ardi wa man feehinna, wa lakal-hamdu Anta Rabbus-samaawaati wal-ardi wa man feehinna, wa lakal-hamdu laka mulkus-samaawaati wal-ardi wa man feehinna, wa lakal-hamdu Anta Malikus-samaawaati wal-ard, wa lakal-hamdu, Antal-Haqqu, wa wa\'dukal-haqqu, wa qawlukal-haqqu, wa liqaa\'ukal-haqqu, wal-jannatu haqqun, wan-naaru haqqun, wan-nabiyyoona haqqun, wa Muhammadun sallallaahu \'alayhi wa sallama haqqun, was-saa\'atu haqqun, Allaahumma laka aslamtu, wa \'alayka tawakkaltu, wa bika aamantu, wa ilayka anabtu, wa bika khaasamtu, wa ilayka haakamtu. Faghfir lee maa qaddamtu wa maa akhkhartu, wa maa asrartu wa maa a\'lantu, Antal-Muqaddimu wa Antal-Mu\'akhkhiru laa ilaaha illaa Anta Anta ilaahee laa ilaaha illaa Ant.',
      translation: 'O Allah, to You belongs all praise, You are the Light of the heavens and the earth and all that is within them. To You belongs all praise, You are the Sustainer of the heavens and the earth and all that is within them. To You belongs all praise, You are the Lord of the heavens and the earth and all that is within them. To You belongs all praise, to You belongs the sovereignty of the heavens and the earth and all that is within them. To You belongs all praise, You are the King of the heavens and the earth. To You belongs all praise, You are the Truth, Your promise is true, Your word is true, and the meeting with You is true. Paradise is true and the Fire is true. The Prophets are true and Muhammad peace and blessings be upon him is true. The Hour is true. O Allah, unto You I have submitted, and upon You I have relied, and in You I have believed, and to You I have turned in repentance, and over You I have disputed, and to You I have turned for judgment. So forgive me for what has come to pass of my sins and what will come to pass, and what I have hidden and what I have made public. You are the One Who brings forward and You are the One Who puts back. None has the right to be worshipped except You. You are my Deity, none has the right to be worshipped except You.',
      reference: 'Al-Bukhari in Fath Al-Bari 3/3, 11/116, 13/371, 423, 465, Muslim 1/532',
      targetCount: 1,
      audioUrl: 'assets/audio/opening_takbeer_6.mp3',
    ),
  ];

  // --- AFTER TASHAHHUD / BEFORE SALAM (HISN AL-MUSLIM CH. 24) ---
  static final List<AzkarItem> afterTashahhud = [
    // 1. Allaahumma innee a'oodhu bika min 'adhaabil-qabr (Hisn al-Muslim #55)
    AzkarItem(
      arabic: 'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنْ عَذَابِ الْقَبْرِ، وَمِنْ عَذَابِ جَهَنَّمَ، وَمِنْ فِتْنَةِ الْمَحْيَا وَالْمَمَاتِ، وَمِنْ شَرِّ فِتْنَةِ الْمَسِيحِ الدَّجَّالِ.',
      transliteration: 'Allaahumma innee a\'oodhu bika min \'adhaabil-qabr, wa min \'adhaabi jahannam, wa min fitnatil-mahyaa wal-mamaat, wa min sharri fitnatil-maseehid-dajjaal.',
      translation: 'O Allah, I take refuge in You from the punishment of the grave, from the torment of the Fire, from the trials and tribulations of life and death and from the evil affliction of Al-Masih Ad-Dajjal.',
      reference: 'Al-Bukhari 2/102, Muslim 1/412',
      targetCount: 1,
      audioUrl: 'assets/audio/after_tashahhud_1.mp3',
    ),
    // 2. Allaahumma innee a'oodhu bika min 'adhaabil-qabr... wal-ma'thami wal-maghram (Hisn al-Muslim #56)
    AzkarItem(
      arabic: 'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنْ عَذَابِ الْقَبْرِ، وَأَعُوذُ بِكَ مِنْ فِتْنَةِ الْمَسِيحِ الدَّجَّالِ، وَأَعُوذُ بِكَ مِنْ فِتْنَةِ الْمَحْيَا وَالْمَمَاتِ. اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْمَأْثَمِ وَالْمَغْرَمِ.',
      transliteration: 'Allaahumma innee a\'oodhu bika min \'adhaabil-qabr, wa a\'oodhu bika min fitnatil-maseehid-dajjaal, wa a\'oodhu bika min fitnatil-mahyaa wal-mamaat. Allaahumma innee a\'oodhu bika minal-ma\'thami wal-maghram.',
      translation: 'O Allah, I take refuge in You from the punishment of the grave, and I take refuge in You from the affliction of Al-Masih Ad-Dajjal, and I take refuge in You from the trials and tribulations of life and death. O Allah, I take refuge in You from sin and heavy debt.',
      reference: 'Al-Bukhari 1/202, Muslim 1/412',
      targetCount: 1,
      audioUrl: 'assets/audio/after_tashahhud_2.mp3',
    ),
    // 3. Allaahumma innee dhalamtu nafsee dhulman katheeraa (Hisn al-Muslim #57)
    AzkarItem(
      arabic: 'اللَّهُمَّ إِنِّي ظَلَمْتُ نَفْسِي ظُلْمًا كَثِيرًا، وَلَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ، فَاغْفِرْ لِي مَغْفِرَةً مِنْ عِنْدِكَ وَارْحَمْنِي إِنَّكَ أَنْتَ الْغَفُورُ الرَّحِيمُ.',
      transliteration: 'Allaahumma innee dhalamtu nafsee dhulman katheeraa, wa laa yaghfirudh-dhunooba illaa Ant, faghfir lee maghfiratan min \'indika warhamnee innaka Antal-Ghafoorur-Raheem.',
      translation: 'O Allah, verily I have wronged myself much and none can forgive sins except You, so forgive me out of Your forgiveness and have mercy on me, verily You are the Oft-Forgiving, Most-Merciful.',
      reference: 'Al-Bukhari 8/168, Muslim 4/2078',
      targetCount: 1,
      audioUrl: 'assets/audio/after_tashahhud_3.mp3',
    ),
    // 4. Allaahummagh-fir lee maa qaddamtu wa maa akhkhartu (Hisn al-Muslim #58)
    AzkarItem(
      arabic: 'اللَّهُمَّ اغْفِرْ لِي مَا قَدَّمْتُ، وَمَا أَخَّرْتُ، وَمَا أَسْرَرْتُ، وَمَا أَعْلَنْتُ، وَمَا أَسْرَفْتُ، وَمَا أَنْتَ أَعْلَمُ بِهِ مِنِّي. أَنْتَ الْمُقَدِّمُ، وَأَنْتَ الْمُؤَخِّرُ لَا إِلَهَ إِلَّا أَنْتَ.',
      transliteration: 'Allaahummagh-fir lee maa qaddamtu, wa maa akhkhartu, wa maa asrartu, wa maa a\'lantu, wa maa asraftu, wa maa Anta a\'lamu bihi minnee. Antal-Muqaddimu, wa Antal-Mu\'akhkhiru laa ilaaha illaa Ant.',
      translation: 'O Allah, forgive me for what I have sent before me and what I have left behind me, what I have concealed and what I have done openly, what I have done in excess and what You are better aware of than I. You are the One Who brings forward and You are the One Who puts back, none has the right to be worshipped except You.',
      reference: 'Muslim 1/534',
      targetCount: 1,
      audioUrl: 'assets/audio/after_tashahhud_4.mp3',
    ),
    // 5. Allaahumma a'innee 'alaa dhikrika (Hisn al-Muslim #59)
    AzkarItem(
      arabic: 'اللَّهُمَّ أَعِنِّي عَلَى ذِكْرِكَ، وَشُكْرِكَ، وَحُسْنِ عِبَادَتِكَ.',
      transliteration: 'Allaahumma a\'innee \'alaa dhikrika, wa shukrika, wa husni \'ibaadatik.',
      translation: 'O Allah, help me to remember You, to give thanks to You, and to worship You in the best of manners.',
      reference: 'Abu Dawud 2/86, An-Nasa\'i 3/53',
      targetCount: 1,
      audioUrl: 'assets/audio/after_tashahhud_5.mp3',
    ),
    // 6. Allaahumma innee a'oodhu bika minal-bukhl (Hisn al-Muslim #60)
    AzkarItem(
      arabic: 'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْبُخْلِ، وَأَعُوذُ بِكَ مِنَ الْجُبْنِ، وَأَعُوذُ بِكَ مِنْ أَنْ أُرَدَّ إِلَى أَرْذَلِ الْعُمُرِ، وَأَعُوذُ بِكَ مِنْ فِتْنَةِ الدُّنْيَا وَعَذَابِ الْقَبْرِ.',
      transliteration: 'Allaahumma innee a\'oodhu bika minal-bukhl, wa a\'oodhu bika minal-jubn, wa a\'oodhu bika min an uradda ilaa ardhalil-\'umur, wa a\'oodhu bika min fitnatid-dunyaa wa \'adhaabil-qabr.',
      translation: 'O Allah, I take refuge in You from miserliness and I take refuge in You from cowardice, and I take refuge in You from being returned to the feeblest age, and I take refuge in You from the trials and tribulations of this life and the punishment of the grave.',
      reference: 'Al-Bukhari in Fath Al-Bari 6/35',
      targetCount: 1,
      audioUrl: 'assets/audio/after_tashahhud_6.mp3',
    ),
    // 7. Allaahumma innee as'alukal-jannah (Hisn al-Muslim #61)
    AzkarItem(
      arabic: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ الْجَنَّةَ وَأَعُوذُ بِكَ مِنَ النَّارِ.',
      transliteration:
          'Allaahumma innee as\'alukal-jannata wa a\'oodhu bika minan-naar.',
      translation: 'O Allah, I ask You for Paradise and I take refuge in You from the Fire.',
      reference: 'Abu Dawud 792, Ibn Majah 2/328',
      targetCount: 1,
      audioUrl: 'assets/audio/after_tashahhud_7.mp3',
    ),
    // 8. Allaahumma bi-'ilmikal-ghayb (Hisn al-Muslim #62)
    AzkarItem(
      arabic: 'اللَّهُمَّ بِعِلْمِكَ الْغَيْبَ وَقُدْرَتِكَ عَلَى الْخَلْقِ أَحْيِنِي مَا عَلِمْتَ الْحَيَاةَ خَيْرًا لِي وَتَوَفَّنِي إِذَا عَلِمْتَ الْوَفَاةَ خَيْرًا لِي، اللَّهُمَّ إِنِّي أَسْأَلُكَ خَشْيَتَكَ فِي الْغَيْبِ وَالشَّهَادَةِ، وَأَسْأَلُكَ كَلِمَةَ الْحَقِّ فِي الرِّضَا وَالْغَضَبِ، وَأَسْأَلُكَ الْقَصْدَ فِي الْغِنَى وَالْفَقْرِ، وَأَسْأَلُكَ نَعِيمًا لَا يَنْفَدُ، وَأَسْأَلُكَ قُرَّةَ عَيْنٍ لَا تَنْقَطِعُ، وَأَسْأَلُكَ الرِّضَا بَعْدَ الْقَضَاءِ، وَأَسْأَلُكَ بَرْدَ الْعَيْشِ بَعْدَ الْمَوْتِ، وَأَسْأَلُكَ لَذَّةَ النَّظَرِ إِلَى وَجْهِكَ وَالشَّوْقَ إِلَى لِقَائِكَ فِي غَيْرِ ضَرَّاءَ مُضِرَّةٍ وَلَا فِتْنَةٍ مُضِلَّةٍ، اللَّهُمَّ زَيِّنَّا بِزِينَةِ الْإِيمَانِ وَاجْعَلْنَا هُدَاةً مُهْتَدِينَ.',
      transliteration: 'Allaahumma bi-\'ilmikal-ghayba wa qudratika \'alal-khalqi ahyinee maa \'alimtal-hayaata khayran lee wa tawaffanee idhaa \'alimtal-wafaata khayran lee, Allaahumma innee as\'aluka khashyataka fil-ghaybi wash-shahaadah, wa as\'aluka kalimatal-haqqi fir-ridaa wal-ghadab, wa as\'alukal-qasda fil-ghinaa wal-faqr, wa as\'aluka na\'eeman laa yanfad, wa as\'aluka qurrata \'aynin laa tanqati\', wa as\'alukar-ridaa ba\'dal-qadaa\', wa as\'aluka bardal-\'ayshi ba\'dal-mawt, wa as\'aluka ladhdhatan-nadhari ilaa wajhika wash-shawqa ilaa liqaa\'ika fee ghayri darraa\'a mudirratin wa laa fitnatin mudillah, Allaahumma zayyinnaa bi-zeenatil-eemaani waj\'alnaa hudaatan muhtadeen.',
      translation: 'O Allah, by Your knowledge of the unseen and by Your power over creation, let me live if life is good for me, and let me die if death is good for me. O Allah, I ask You to grant me fear of You in private and in public. I ask You for the word of truth in times of contentment and anger. I ask You for moderation in wealth and in poverty. I ask You for blessings never ceasing and the coolness of my eye never ending. I ask You for pleasure after Your judgment and I ask You for a life of coolness after death. I ask You for the delight of gazing upon Your Face and the joy of meeting You without any harm and misleading trials befalling me. O Allah, dress us with the beauty of Faith and make us guides who are upon guidance.',
      reference: 'An-Nasa\'i 3/54-55, Ahmad 4/364',
      targetCount: 1,
      audioUrl: 'assets/audio/after_tashahhud_8.mp3',
    ),
    // 9. Allaahumma innee as'aluka yaa Allaah (Hisn al-Muslim #63)
    AzkarItem(
      arabic: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ يَا اللَّهُ بِأَنَّكَ الْوَاحِدُ الْأَحَدُ الصَّمَدُ الَّذِي لَمْ يَلِدْ وَلَمْ يُولَدْ وَلَمْ يَكُنْ لَهُ كُفُوًا أَحَدٌ، أَنْ تَغْفِرَ لِي ذُنُوبِي إِنَّكَ أَنْتَ الْغَفُورُ الرَّحِيمُ.',
      transliteration: 'Allaahumma innee as\'aluka yaa Allaahu bi-annakal-Waahidul-Ahadus-Samadul-ladhee lam yalid wa lam yoolad wa lam yakun lahu kufuwan ahad, an taghfira lee dhunoobee innaka Antal-Ghafoorur-Raheem.',
      translation: 'O Allah, I ask You, O Allah, as You are the One, the Only, the Self-Sufficient Master, Who begets not nor was begotten and there is none equal or comparable to Him, to forgive me my sins, verily You are the Oft-Forgiving, Most-Merciful.',
      reference: 'An-Nasa\'i 3/52, Ahmad 4/338',
      targetCount: 1,
      audioUrl: 'assets/audio/after_tashahhud_9.mp3',
    ),
    // 10. Allaahumma innee as'aluka bi-anna lakal-hamd (Hisn al-Muslim #64)
    AzkarItem(
      arabic: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ بِأَنَّ لَكَ الْحَمْدَ لَا إِلَهَ إِلَّا أَنْتَ وَحْدَكَ لَا شَرِيكَ لَكَ، الْمَنَّانُ، يَا بَدِيعَ السَّمَاوَاتِ وَالْأَرْضِ يَا ذَا الْجَلَالِ وَالْإِكْرَامِ، يَا حَيُّ يَا قَيُّومُ إِنِّي أَسْأَلُكَ الْجَنَّةَ وَأَعُوذُ بِكَ مِنَ النَّارِ.',
      transliteration: 'Allaahumma innee as\'aluka bi-anna lakal-hamda laa ilaaha illaa Anta wahdaka laa shareeka laka, al-Mannaan, yaa Badee\'as-samaawaati wal-ardi yaa Dhal-Jalaali wal-Ikraam, yaa Hayyu yaa Qayyoomu innee as\'alukal-jannata wa a\'oodhu bika minan-naar.',
      translation: 'O Allah, I ask You, as to You belongs all praise, none has the right to be worshipped except You alone, without partner, the Bestower. O Originator of the heavens and the earth, O Possessor of majesty and honour, O Ever-Living, O Self-Subsisting and Supporter of all, verily I ask You for Paradise and I take refuge with You from the Fire.',
      reference:
          'Abu Dawud 1495, An-Nasa\'i 3/52, Ibn Majah 3858, At-Tirmidhi 3544',
      targetCount: 1,
      audioUrl: 'assets/audio/after_tashahhud_10.mp3',
    ),
    // 11. Allaahumma innee as'aluka bi-annee ash-hadu (Hisn al-Muslim #65)
    AzkarItem(
      arabic: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ بِأَنِّي أَشْهَدُ أَنَّكَ أَنْتَ اللَّهُ لَا إِلَهَ إِلَّا أَنْتَ الْأَحَدُ الصَّمَدُ الَّذِي لَمْ يَلِدْ وَلَمْ يُولَدْ وَلَمْ يَكُنْ لَهُ كُفُوًا أَحَدٌ.',
      transliteration: 'Allaahumma innee as\'aluka bi-annee ash-hadu annaka Antallaahu laa ilaaha illaa Antal-Ahadus-Samadul-ladhee lam yalid wa lam yoolad wa lam yakun lahu kufuwan ahad.',
      translation: 'O Allah, I ask You as I bear witness that You are Allah, none has the right to be worshipped except You, the Only, the Self-Sufficient Master, Who begets not nor was begotten and there is none equal or comparable to Him.',
      reference:
          'Abu Dawud 2/62, At-Tirmidhi 5/515, Ibn Majah 2/1267, Ahmad 5/360',
      targetCount: 1,
      audioUrl: 'assets/audio/after_tashahhud_11.mp3',
    ),
  ];

  // --- DURING SUJOOD (HISN AL-MUSLIM CH. 19) ---
  static final List<AzkarItem> duringSujood = [
    // 1. Subhaana Rabbiyal-A'laa (Hisn al-Muslim #41)
    AzkarItem(
      arabic: 'سُبْحَانَ رَبِّيَ الْأَعْلَى.',
      transliteration: 'Subhaana Rabbiyal-A\'laa.',
      translation: 'How perfect my Lord is, the Most High.',
      reference: 'Abu Dawud 1/230, Ibn Majah 1/287, At-Tirmidhi 2/47, An-Nasa\'i 2/190',
      targetCount: 3,
      audioUrl: 'assets/audio/sujood_1.mp3',
    ),
    // 2. Subhaanakallaahumma Rabbanaa wa bi-hamdika (Hisn al-Muslim #42)
    AzkarItem(
      arabic: 'سُبْحَانَكَ اللَّهُمَّ رَبَّنَا وَبِحَمْدِكَ، اللَّهُمَّ اغْفِرْ لِي.',
      transliteration:
          'Subhaanakallaahumma Rabbanaa wa bi-hamdika, Allaahummagh-fir lee.',
      translation: 'How perfect You are O Allah, our Lord, and I praise You. O Allah, forgive me.',
      reference: 'Al-Bukhari 1/99, Muslim 1/350',
      targetCount: 1,
      audioUrl: 'assets/audio/sujood_2.mp3',
    ),
    // 3. Subboohun Quddoosun (Hisn al-Muslim #43)
    AzkarItem(
      arabic: 'سُبُّوحٌ، قُدُّوسٌ، رَبُّ الْمَلَائِكَةِ وَالرُّوحِ.',
      transliteration: 'Subboohun, Quddoosun, Rabbul-malaa\'ikati war-Rooh.',
      translation: 'Perfect and Holy, Lord of the angels and the Spirit.',
      reference: 'Muslim 1/353, Abu Dawud 1/230',
      targetCount: 1,
      audioUrl: 'assets/audio/sujood_3.mp3',
    ),
    // 4. Allaahumma laka sajadtu (Hisn al-Muslim #44)
    AzkarItem(
      arabic: 'اللَّهُمَّ لَكَ سَجَدْتُ وَبِكَ آمَنْتُ، وَلَكَ أَسْلَمْتُ، سَجَدَ وَجْهِيَ لِلَّذِي خَلَقَهُ، وَصَوَّرَهُ، وَشَقَّ سَمْعَهُ وَبَصَرَهُ، تَبَارَكَ اللَّهُ أَحْسَنُ الْخَالِقِينَ.',
      transliteration: 'Allaahumma laka sajadtu wa bika aamantu, wa laka aslamtu, sajada wajhiya lilladhee khalaqahu, wa sawwarahu, wa shaqqa sam\'ahu wa basarahu, tabaarakallaahu ahsanul-khaaliqeen.',
      translation: 'O Allah, unto You I have prostrated and in You I have believed, and unto You I have submitted. My face has prostrated before He Who created it and fashioned it, and brought forth its faculties of hearing and seeing. Blessed is Allah, the Best of creators.',
      reference: 'Muslim 1/534',
      targetCount: 1,
      audioUrl: 'assets/audio/sujood_4.mp3',
    ),
    // 5. Subhaana Dhil-Jabarooti wal-Malakoot (Hisn al-Muslim #45)
    AzkarItem(
      arabic: 'سُبْحَانَ ذِي الْجَبَرُوتِ، وَالْمَلَكُوتِ، وَالْكِبْرِيَاءِ، وَالْعَظَمَةِ.',
      transliteration: 'Subhaana Dhil-Jabarooti, wal-Malakooti, wal-Kibriyaa\'i, wal-\'Adhamah.',
      translation: 'How perfect is the Possessor of total power, sovereignty, magnificence and grandeur.',
      reference: 'Abu Dawud 1/230, An-Nasa\'i 2/222, Ahmad 6/24',
      targetCount: 1,
      audioUrl: 'assets/audio/sujood_5.mp3',
    ),
    // 6. Allaahummagh-fir lee dhanbee kullahu (Hisn al-Muslim #46)
    AzkarItem(
      arabic: 'اللَّهُمَّ اغْفِرْ لِي ذَنْبِي كُلَّهُ: دِقَّهُ وَجِلَّهُ، وَأَوَّلَهُ وَآخِرَهُ، وَعَلَانِيَتَهُ وَسِرَّهُ.',
      transliteration: 'Allaahummagh-fir lee dhanbee kullahu: diqqahu wa jillahu, wa awwalahu wa aakhirahu, wa \'alaaniyatahu wa sirrahu.',
      translation: 'O Allah, forgive me all of my sins: the small and the great of them, the first and the last of them, and the seen and the hidden of them.',
      reference: 'Muslim 1/350',
      targetCount: 1,
      audioUrl: 'assets/audio/sujood_6.mp3',
    ),
    // 7. Allaahumma innee a'oodhu bi-ridaaka min sakhatika (Hisn al-Muslim #47)
    AzkarItem(
      arabic: 'اللَّهُمَّ إِنِّي أَعُوذُ بِرِضَاكَ مِنْ سَخَطِكَ، وَبِمُعَافَاتِكَ مِنْ عُقُوبَتِكَ، وَأَعُوذُ بِكَ مِنْكَ، لَا أُحْصِي ثَنَاءً عَلَيْكَ، أَنْتَ كَمَا أَثْنَيْتَ عَلَى نَفْسِكَ.',
      transliteration: 'Allaahumma innee a\'oodhu bi-ridaaka min sakhatika, wa bi-mu\'aafaatika min \'uqoobatika, wa a\'oodhu bika minka, laa uhsee thanaa\'an \'alayka, Anta kamaa athnayta \'alaa nafsik.',
      translation: 'O Allah, I take refuge within Your pleasure from Your displeasure and within Your pardon from Your punishment, and I take refuge in You from You. I cannot enumerate Your praise. You are as You have praised Yourself.',
      reference: 'Muslim 1/352',
      targetCount: 1,
      audioUrl: 'assets/audio/sujood_7.mp3',
    ),
  ];

  // --- UPON HEARING THE ADHAN (HISN AL-MUSLIM CH. 15) ---
  static final List<AzkarItem> hearingAdhan = [
    // 1. Repeating after the Mu'adhdhin (Hisn al-Muslim #22)
    AzkarItem(
      arabic: 'يَقُولُ مِثْلَ مَا يَقُولُ الْمُؤَذِّنُ إِلَّا فِي «حَيَّ عَلَى الصَّلَاةِ» وَ«حَيَّ عَلَى الْفَلَاحِ» فَيَقُولُ: لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ.',
      transliteration: 'Repeat what the Mu\'adhdhin says, except when he says "Hayya \'alas-Salaah" and "Hayya \'alal-Falaah", where you say: Laa hawla wa laa quwwata illaa billaah.',
      translation: 'One repeats what the Mu\'adhdhin says, except when he says "Come to prayer" and "Come to success", in which case one says: "There is no might and no power except with Allah."',
      reference: 'Al-Bukhari 1/152, Muslim 1/288',
      targetCount: 1,
      audioUrl: 'assets/audio/athan_1.mp3',
    ),
    // 2. Upon hearing the Tashahhud of the Adhan (Hisn al-Muslim #23)
    AzkarItem(
      arabic: 'وَأَنَا أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ وَأَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ، رَضِيتُ بِاللَّهِ رَبًّا، وَبِمُحَمَّدٍ رَسُولًا، وَبِالْإِسْلَامِ دِينًا.',
      transliteration: 'Wa ana ash-hadu an laa ilaaha illallaahu wahdahu laa shareeka lahu wa anna Muhammadan \'abduhu wa Rasooluh, radeetu billaahi Rabban, wa bi-Muhammadin Rasoolan, wa bil-Islaami deenaa.',
      translation: 'And I bear witness that none has the right to be worshipped except Allah, alone, without partner, and that Muhammad is His servant and Messenger. I am pleased with Allah as a Lord, with Muhammad as a Messenger, and with Islam as a religion. [To be recited after the Mu\'adhdhin\'s tashahhud]',
      reference: 'Muslim 1/290, Ibn Khuzaymah 1/220',
      targetCount: 1,
      audioUrl: 'assets/audio/athan_2.mp3',
    ),
    // 3. Sending Salah upon the Prophet after answering the Adhan (Hisn al-Muslim #24)
    AzkarItem(
      arabic: 'اللَّهُمَّ صَلِّ وَسَلِّمْ عَلَى نَبِيِّنَا مُحَمَّدٍ.',
      transliteration: 'Allaahumma salli wa sallim \'alaa nabiyyinaa Muhammad.',
      translation: 'O Allah, send prayers and peace upon our Prophet Muhammad. [Recite Salah upon the Prophet after answering the Mu\'adhdhin]',
      reference: 'Muslim 1/288',
      targetCount: 1,
      audioUrl: 'assets/audio/athan_3.mp3',
    ),
    // 4. Allaahumma Rabba haadhihid-da'watit-taammah (Hisn al-Muslim #25)
    AzkarItem(
      arabic: 'اللَّهُمَّ رَبَّ هَذِهِ الدَّعْوَةِ التَّامَّةِ، وَالصَّلَاةِ الْقَائِمَةِ، آتِ مُحَمَّدًا الْوَسِيلَةَ وَالْفَضِيلَةَ، وَابْعَثْهُ مَقَامًا مَحْمُودًا الَّذِي وَعَدْتَهُ، [إِنَّكَ لَا تُخْلِفُ الْمِيعَادَ].',
      transliteration: 'Allaahumma Rabba haadhihid-da\'watit-taammah, was-salaatil-qaa\'imah, aati Muhammadanil-waseelata wal-fadeelah, wab\'ath-hu maqaaman mahmoodanil-ladhee wa\'adtah, [innaka laa tukhliful-mee\'aad].',
      translation: 'O Allah, Lord of this perfect call and established prayer. Grant Muhammad the intercession and favour, and raise him to the honoured station You have promised him, [verily You do not neglect promises].',
      reference: 'Al-Bukhari 1/152, Al-Bayhaqi 1/410',
      targetCount: 1,
      audioUrl: 'assets/audio/athan_4.mp3',
    ),
    // 5. Supplicating between the Adhan and Iqamah (Hisn al-Muslim #26)
    AzkarItem(
      arabic: 'يَدْعُو لِنَفْسِهِ بَيْنَ الْأَذَانِ وَالْإِقَامَةِ فَإِنَّ الدُّعَاءَ حِينَئِذٍ لَا يُرَدُّ.',
      transliteration: 'Supplicate to Allah for yourself between the Adhan and the Iqamah, for supplication at that time is not rejected.',
      translation: 'One should supplicate for oneself between the Adhan and the Iqamah, for verily supplication at that time is not rejected.',
      reference: 'At-Tirmidhi, Abu Dawud, Ahmad',
      targetCount: 1,
      audioUrl: 'assets/audio/athan_5.mp3',
    ),
  ];

  // --- DURING RUKU (HISN AL-MUSLIM CH. 17) ---
  static final List<AzkarItem> duringRuku = [
    // 1. Subhaana Rabbiyal-'Adheem (Hisn al-Muslim #33)
    AzkarItem(
      arabic: 'سُبْحَانَ رَبِّيَ الْعَظِيمِ.',
      transliteration: 'Subhaana Rabbiyal-\'Adheem.',
      translation: 'How perfect my Lord is, the Supreme.',
      reference: 'Abu Dawud 1/230, Ibn Majah 1/287, At-Tirmidhi 2/47, An-Nasa\'i 2/190',
      targetCount: 3,
      audioUrl: 'assets/audio/ruku_1.mp3',
    ),
    // 2. Subhaanakallaahumma Rabbanaa wa bi-hamdika (Hisn al-Muslim #34)
    AzkarItem(
      arabic: 'سُبْحَانَكَ اللَّهُمَّ رَبَّنَا وَبِحَمْدِكَ، اللَّهُمَّ اغْفِرْ لِي.',
      transliteration:
          'Subhaanakallaahumma Rabbanaa wa bi-hamdika, Allaahummagh-fir lee.',
      translation: 'How perfect You are O Allah, our Lord, and I praise You. O Allah, forgive me.',
      reference: 'Al-Bukhari 1/99, Muslim 1/350',
      targetCount: 1,
      audioUrl: 'assets/audio/ruku_2.mp3',
    ),
    // 3. Subboohun Quddoosun (Hisn al-Muslim #35)
    AzkarItem(
      arabic: 'سُبُّوحٌ، قُدُّوسٌ، رَبُّ الْمَلَائِكَةِ وَالرُّوحِ.',
      transliteration: 'Subboohun, Quddoosun, Rabbul-malaa\'ikati war-Rooh.',
      translation: 'Perfect and Holy, Lord of the angels and the Spirit.',
      reference: 'Muslim 1/353, Abu Dawud 1/230',
      targetCount: 1,
      audioUrl: 'assets/audio/ruku_3.mp3',
    ),
    // 4. Allaahumma laka raka'tu (Hisn al-Muslim #36)
    AzkarItem(
      arabic: 'اللَّهُمَّ لَكَ رَكَعْتُ، وَبِكَ آمَنْتُ، وَلَكَ أَسْلَمْتُ، خَشَعَ لَكَ سَمْعِي، وَبَصَرِي، وَمُخِّي، وَعَظْمِي، وَعَصَبِي، وَمَا اسْتَقَلَّتْ بِهِ قَدَمِي.',
      transliteration: 'Allaahumma laka raka\'tu, wa bika aamantu, wa laka aslamtu, khasha\'a laka sam\'ee, wa basaree, wa mukhkhee, wa \'adhmee, wa \'asabee, wa mastaqallat bihi qadamee.',
      translation: 'O Allah, unto You I have bowed, and in You I have believed, and unto You I have submitted. My hearing, my sight, my mind, my bones, my tendons and what my feet carry are humbled before You.',
      reference:
          'Muslim 1/534, Abu Dawud 1/202, At-Tirmidhi 5/484, An-Nasa\'i 2/191',
      targetCount: 1,
      audioUrl: 'assets/audio/ruku_4.mp3',
    ),
    // 5. Subhaana Dhil-Jabarooti wal-Malakoot (Hisn al-Muslim #37)
    AzkarItem(
      arabic: 'سُبْحَانَ ذِي الْجَبَرُوتِ، وَالْمَلَكُوتِ، وَالْكِبْرِيَاءِ، وَالْعَظَمَةِ.',
      transliteration: 'Subhaana Dhil-Jabarooti, wal-Malakooti, wal-Kibriyaa\'i, wal-\'Adhamah.',
      translation: 'How perfect is the Possessor of total power, sovereignty, magnificence and grandeur.',
      reference: 'Abu Dawud 1/230, An-Nasa\'i 2/222, Ahmad 6/24',
      targetCount: 1,
      audioUrl: 'assets/audio/ruku_5.mp3',
    ),
  ];

  // --- BETWEEN THE TWO PROSTRATIONS (HISN AL-MUSLIM CH. 20) ---
  static final List<AzkarItem> betweenTwoSujood = [
    // 1. Rabbigh-fir lee, Rabbigh-fir lee (Hisn al-Muslim #48)
    AzkarItem(
      arabic: 'رَبِّ اغْفِرْ لِي، رَبِّ اغْفِرْ لِي.',
      transliteration: 'Rabbigh-fir lee, Rabbigh-fir lee.',
      translation: 'O my Lord, forgive me. O my Lord, forgive me.',
      reference: 'Abu Dawud 1/231, Ibn Majah 897',
      targetCount: 1,
      audioUrl: 'assets/audio/between_two_sujood_1.mp3',
    ),
    // 2. Allaahummagh-fir lee, warhamnee, wahdinee (Hisn al-Muslim #49)
    AzkarItem(
      arabic: 'اللَّهُمَّ اغْفِرْ لِي، وَارْحَمْنِي، وَاهْدِنِي، وَاجْبُرْنِي، وَعَافِنِي، وَارْزُقْنِي، وَارْفَعْنِي.',
      transliteration: 'Allaahummagh-fir lee, warhamnee, wahdinee, wajburnee, wa \'aafinee, warzuqnee, warfa\'nee.',
      translation: 'O Allah, forgive me, have mercy upon me, guide me, enrich me, give me health, grant me sustenance and raise my rank.',
      reference: 'Abu Dawud, At-Tirmidhi, Ibn Majah',
      targetCount: 1,
      audioUrl: 'assets/audio/between_two_sujood_2.mp3',
    ),
  ];

  // --- ENTERING THE MOSQUE (HISN AL-MUSLIM CH. 13) ---
  static final List<AzkarItem> enteringMosque = [
    // 1. Entering the Mosque (Hisn al-Muslim #20)
    AzkarItem(
      arabic: 'يَبْدَأُ بِرِجْلِهِ الْيُمْنَى، وَيَقُولُ: أَعُوذُ بِاللَّهِ الْعَظِيمِ، وَبِوَجْهِهِ الْكَرِيمِ، وَسُلْطَانِهِ الْقَدِيمِ، مِنَ الشَّيْطَانِ الرَّجِيمِ. [بِسْمِ اللَّهِ، وَالصَّلَاةُ] [وَالسَّلَامُ عَلَى رَسُولِ اللَّهِ] اللَّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ.',
      transliteration: '[Step in with the right foot first and say:] A\'oodhu billaahil-\'Adheem, wa bi-Wajhihil-Kareem, wa Sultaanihil-Qadeem, minash-Shaytaanir-rajeem. [Bismillaahi, was-salaatu] [was-salaamu \'alaa Rasoolillaah] Allaahummaf-tah lee abwaaba rahmatik.',
      translation: '[Step in with the right foot first and say:] I take refuge with Allah, The Supreme and with His Noble Face, and His eternal authority from the accursed devil. [In the name of Allah, and prayers] [and peace be upon the Messenger of Allah]. O Allah, open the gates of Your mercy for me.',
      reference: 'Abu Dawud 1/126 (466), Muslim 1/494 (713), Ibn As-Sunni 88',
      targetCount: 1,
      audioUrl: 'assets/audio/entering_mosque.mp3',
    ),
  ];

  // --- LEAVING THE MOSQUE (HISN AL-MUSLIM CH. 14) ---
  static final List<AzkarItem> leavingMosque = [
    // 1. Leaving the Mosque (Hisn al-Muslim #21)
    AzkarItem(
      arabic: 'يَبْدَأُ بِرِجْلِهِ الْيُسْرَى، وَيَقُولُ: بِسْمِ اللَّهِ وَالصَّلَاةُ وَالسَّلَامُ عَلَى رَسُولِ اللَّهِ، اللَّهُمَّ إِنِّي أَسْأَلُكَ مِنْ فَضْلِكَ، اللَّهُمَّ اعْصِمْنِي مِنَ الشَّيْطَانِ الرَّجِيمِ.',
      transliteration: '[Step out with the left foot first and say:] Bismillaahi was-salaatu was-salaamu \'alaa Rasoolillaah, Allaahumma innee as\'aluka min fadlik, Allaahumma\'simnee minash-Shaytaanir-rajeem.',
      translation: '[Step out with the left foot first and say:] In the name of Allah, and prayers and peace be upon the Messenger of Allah. O Allah, I ask You from Your favour. O Allah, guard me from the accursed devil.',
      reference: 'Muslim 1/494 (713), Ibn Majah 1/253 (773)',
      targetCount: 1,
      audioUrl: 'assets/audio/leaving_mosque.mp3',
    ),
  ];

  // --- BEFORE ABLUTION (HISN AL-MUSLIM CH. 8) ---
  static final List<AzkarItem> beforeAblution = [
    // 1. Bismillaah (Hisn al-Muslim #12)
    AzkarItem(
      arabic: 'بِسْمِ اللَّهِ.',
      transliteration: 'Bismillaah.',
      translation: 'In the name of Allah.',
      reference: 'Abu Dawud 101, Ibn Majah 397, Ahmad 2/418',
      targetCount: 1,
      audioUrl: 'assets/audio/before_ablution.mp3',
    ),
  ];

  // --- UPON COMPLETING ABLUTION (HISN AL-MUSLIM CH. 9) ---
  static final List<AzkarItem> uponCompletingAblution = [
    // 1. Ash-hadu an laa ilaaha illallaah (Hisn al-Muslim #13)
    AzkarItem(
      arabic: 'أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ.',
      transliteration: 'Ash-hadu an laa ilaaha illallaahu wahdahu laa shareeka lahu wa ash-hadu anna Muhammadan \'abduhu wa Rasooluh.',
      translation: 'I bear witness that none has the right to be worshipped except Allah, alone, without partner, and I bear witness that Muhammad is His servant and Messenger.',
      reference: 'Muslim 1/209 (234)',
      targetCount: 1,
      audioUrl: 'assets/audio/upon_completing_ablution_1.mp3',
    ),
    // 2. Allaahummaj-'alnee minat-tawwaabeena (Hisn al-Muslim #14)
    AzkarItem(
      arabic: 'اللَّهُمَّ اجْعَلْنِي مِنَ التَّوَّابِينَ وَاجْعَلْنِي مِنَ الْمُتَطَهِّرِينَ.',
      transliteration: 'Allaahummaj-\'alnee minat-tawwaabeena waj-\'alnee minal-mutatahhireen.',
      translation: 'O Allah, make me of those who return to You often in repentance and make me of those who remain clean and pure.',
      reference: 'At-Tirmidhi 1/78 (55)',
      targetCount: 1,
      audioUrl: 'assets/audio/upon_completing_ablution_2.mp3',
    ),
    // 3. Subhaanakallaahumma wa bi-hamdika (Hisn al-Muslim #15)
    AzkarItem(
      arabic: 'سُبْحَانَكَ اللَّهُمَّ وَبِحَمْدِكَ، أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا أَنْتَ، أَسْتَغْفِرُكَ وَأَتُوبُ إِلَيْكَ.',
      transliteration: 'Subhaanakallaahumma wa bi-hamdika, ash-hadu an laa ilaaha illaa Ant, astaghfiruka wa atoobu ilayk.',
      translation: 'How perfect You are O Allah, and I praise You. I bear witness that none has the right to be worshipped except You. I seek Your forgiveness and turn to You in repentance.',
      reference: 'An-Nasa\'i in Amalul-Yawmi wal-Laylah 173',
      targetCount: 1,
      audioUrl: 'assets/audio/upon_completing_ablution_3.mp3',
    ),
  ];

  // --- ENTERING THE HOME (HISN AL-MUSLIM CH. 11) ---
  static final List<AzkarItem> enteringHome = [
    // 1. Bismillaahi walajnaa (Hisn al-Muslim #18)
    AzkarItem(
      arabic: 'بِسْمِ اللَّهِ وَلَجْنَا، وَبِسْمِ اللَّهِ خَرَجْنَا، وَعَلَى اللَّهِ رَبِّنَا تَوَكَّلْنَا، ثُمَّ لِيُسَلِّمْ عَلَى أَهْلِهِ.',
      transliteration: 'Bismillaahi walajnaa, wa bismillaahi kharajnaa, wa \'alaa Rabbinaa tawakkalnaa, [then greet those present with As-Salaamu \'Alaykum].',
      translation: 'In the name of Allah we enter and in the name of Allah we leave, and upon our Lord we place our trust. [Then say As-Salaamu \'Alaykum to those present].',
      reference: 'Abu Dawud 4/325 (5096)',
      targetCount: 1,
      audioUrl: 'assets/audio/entering_home_1.mp3',
    ),
  ];

  // --- LEAVING THE HOME (HISN AL-MUSLIM CH. 10) ---
  static final List<AzkarItem> leavingHome = [
    // 1. Bismillaahi, tawakkaltu 'alallaah (Hisn al-Muslim #16)
    AzkarItem(
      arabic: 'بِسْمِ اللَّهِ، تَوَكَّلْتُ عَلَى اللَّهِ، وَلَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ.',
      transliteration: 'Bismillaahi, tawakkaltu \'alallaah, wa laa hawla wa laa quwwata illaa billaah.',
      translation: 'In the name of Allah, I place my trust in Allah, and there is no might nor power except with Allah.',
      reference: 'Abu Dawud 4/325 (5095), At-Tirmidhi 5/490 (3426)',
      targetCount: 1,
      audioUrl: 'assets/audio/leaving_home_1.mp3',
    ),

    // 2. Allaahumma innee a'oodhu bika an adilla aw udalla (Hisn al-Muslim #17)
    AzkarItem(
      arabic: 'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ أَنْ أَضِلَّ، أَوْ أُضَلَّ، أَوْ أَزِلَّ، أَوْ أُزَلَّ، أَوْ أَظْلِمَ، أَوْ أُظْلَمَ، أَوْ أَجْهَلَ، أَوْ يُجْهَلَ عَلَيَّ.',
      transliteration: 'Allaahumma innee a\'oodhu bika an adilla, aw udalla, aw azilla, aw uzalla, aw adhlima, aw udhlama, aw ajhala, aw yujhala \'alayya.',
      translation: 'O Allah, I take refuge with You lest I should stray or be led astray, or slip or be tripped, or oppress or be oppressed, or behave foolishly or be treated foolishly.',
      reference: 'Abu Dawud 4/325 (5094), At-Tirmidhi 5/490 (3427), An-Nasa\'i 8/268, Ibn Majah 2/1278 (3884)',
      targetCount: 1,
      audioUrl: 'assets/audio/leaving_home_2.mp3',
    ),
  ];

  // This helper matches the title on the screen to the correct list above
  static List<AzkarItem> getListByTitle(String title) {
    switch (title) {
      case 'Morning Azkar':
        return morning;
      case 'Evening Azkar':
        return evening;
      case 'Before Sleeping Azkar':
        return beforeSleeping;
      case 'Waking Up Azkar':
        return wakingUp;
      case 'After Prayer Azkar':
        return afterPrayer;
      case 'Dua After The Opening Takbeer':
        return afterOpeningTakbeer;
      case 'After Tashahhud Azkar':
        return afterTashahhud;
      case 'Duas During Ruku':
        return duringRuku;
      case 'Duas During Sujood':
        return duringSujood;
      case 'Azkar On Hearing Adhan':
        return hearingAdhan;
      case 'Between Two Sujood':
        return betweenTwoSujood;
      case 'Upon Entering Mosque':
        return enteringMosque;
      case 'Upon Leaving Mosque':
        return leavingMosque;
      case 'Before Performing Ablution':
        return beforeAblution;
      case 'Upon Completing Ablution':
        return uponCompletingAblution;
      case 'Entering the Home':
        return enteringHome;
      case 'Leaving the Home':
        return leavingHome;
      default:
        return [];
    }
  }
}
