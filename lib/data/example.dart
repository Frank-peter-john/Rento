import 'package:rento/models/property_model.dart';
import 'package:rento/models/property_owner.dart';

final owner1 = Owner(
  id: 1,
  name: 'Ndiba empire',
  phoneNumber: '+25575768897',
  email: 'ndibaempire@gmail.com',
  profileImage: 'assets/images/one.jpg',
  properties: [
    Property(
      title: 'ofisi za kupangisha',
      location: 'Azikiwe, Dar es salaam',
      price: 'Tsh 2000/mita mraba',
      description:
          'jengo zuri lenye mandhari mazuri na sehemu kubwa ya parking',
      category: 'Ofisi',
      images: [
        'assets/images/deborah-cortelazzi-gREquCUXQLI-unsplash.jpg',
        'assets/images/office1.jpg',
        'assets/images/office2.jpg',
        'assets/images/damir-kopezhanov-nC6CyrVBtkU-unsplash.jpg',
      ],
    ),
    Property(
      title: 'ofisi za kupangisha',
      location: 'Mikocheni, Dar es salaam',
      price: 'Tsh 4000/mita mraba',
      description:
          'jengo zuri lenye maandari mazuri na sehemu kubwa ya parking',
      category: 'Ofisi',
      images: [
        'assets/images/office.jpg',
        'assets/images/office1.jpg',
        'assets/images/deborah-cortelazzi-gREquCUXQLI-unsplash.jpg',
        'assets/images/point3d-commercial-imaging-ltd-Cu2xZLKgn10-unsplash.jpg',
        'assets/images/damir-kopezhanov-nC6CyrVBtkU-unsplash.jpg',
      ],
    ),
  ],
);

final owner2 = Owner(
  id: 2,
  name: 'Frank P John',
  phoneNumber: '+2557576456723',
  email: 'frank@gmail.com',
  profileImage: 'assets/images/fou.jpg',
  properties: [
    Property(
      title: 'Mansheni kali',
      location: 'Njiro, Arusha',
      price: 'Tsh 200,000/mwezi',
      description: 'Nyumba nzuri na bora. Ina utulivu, haina mbambamba',
      category: 'Nyumba ya kupanga',
      images: [
        'assets/images/danielle-cerullo-dN7085rORJo-unsplash.jpg',
        'assets/images/ralph-ravi-kayden-FqqiAvJejto-unsplash.jpg',
        'assets/images/damir-kopezhanov-nC6CyrVBtkU-unsplash.jpg',
        'assets/images/kilimanjaro.jpeg',
        'assets/images/office1.jpg',
        'assets/images/patrick-perkins-3wylDrjxH-E-unsplash.jpg',
      ],
    ),
    Property(
      title: 'Mansheni kali',
      location: 'Njiro, Arusha',
      price: 'Tsh 200,000/mwezi',
      description: 'Nyumba nzuri na bora. Ina utulivu, haina mbambamba',
      category: 'Nyumba ya kupanga',
      images: [
        'assets/images/patrick-perkins-3wylDrjxH-E-unsplash.jpg',
        'assets/images/kilimanjaro.jpeg',
        'assets/images/office1.jpg',
        'assets/images/danielle-cerullo-dN7085rORJo-unsplash.jpg',
        'assets/images/damir-kopezhanov-nC6CyrVBtkU-unsplash.jpg',
        'assets/images/ralph-ravi-kayden-FqqiAvJejto-unsplash.jpg',
      ],
    ),
  ],
);

final owner3 = Owner(
  id: 3,
  name: 'Ibaru Johns',
  phoneNumber: '+255734847243',
  email: 'ibarujohns@gmail.com',
  profileImage: 'assets/images/one.jpg',
  properties: [
    Property(
      title: 'Ndiba complex',
      location: 'Nyasaka, Mwanza',
      price: 'Tsh 1,000,000/mwezi',
      description: 'Fremu nzuri kali, Zina feni ndani, Vyumba vikubwa',
      category: 'Fremu',
      images: [
        'assets/images/danielle-cerullo-dN7085rORJo-unsplash.jpg',
        'assets/images/ralph-ravi-kayden-FqqiAvJejto-unsplash.jpg',
        'assets/images/damir-kopezhanov-nC6CyrVBtkU-unsplash.jpg',
        'assets/images/kilimanjaro.jpeg',
        'assets/images/office1.jpg',
        'assets/images/patrick-perkins-3wylDrjxH-E-unsplash.jpg',
      ],
    ),
    Property(
      title: 'Ndiba apartments',
      location: 'Kilima hewa, Mwanza',
      price: 'Tsh 200,000/mwezi',
      description:
          'Nyumba nzuri na bora. Ina utulivu, haina mbambamba.Nyumba nzuri na bora. Ina utulivu, haina mbambamba.Nyumba nzuri na bora. Ina utulivu, haina mbambamba.Nyumba nzuri na bora. Ina utulivu, haina mbambamba',
      category: 'Nyumba ya kupanga',
      images: [
        'assets/images/office1.jpg',
        'assets/images/patrick-perkins-3wylDrjxH-E-unsplash.jpg',
        'assets/images/kilimanjaro.jpeg',
        'assets/images/danielle-cerullo-dN7085rORJo-unsplash.jpg',
        'assets/images/damir-kopezhanov-nC6CyrVBtkU-unsplash.jpg',
        'assets/images/ralph-ravi-kayden-FqqiAvJejto-unsplash.jpg',
      ],
    ),
  ],
);

final List<Owner> owners = [
  owner1,
  owner2,
  owner3,
];
