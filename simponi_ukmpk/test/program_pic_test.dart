import 'package:flutter_test/flutter_test.dart';
import 'package:simponi_ukmpk/data/models/program_model.dart';
import 'package:simponi_ukmpk/features/program_kerja/screens/program_kerja_form_screen.dart';

void main() {
  group('Program Kerja PIC Feature Tests', () {
    test('ProgramModel maps pic_id, picName, and picNim from API response', () {
      final json = {
        'id': 10,
        'division_id': 2,
        'division': {'id': 2, 'name': 'Divisi Penalaran & Keilmuan'},
        'pic_id': 4, // members.id
        'pic': {
          'id': 4, // members.id
          'user_id': 8, // users.id (different from members.id)
          'nim': '21051204050',
          'user': {
            'id': 8,
            'name': 'Muhammad Rizky',
            'email': 'rizky@unesa.ac.id',
          },
        },
        'name': 'Pelatihan Karya Tulis Ilmiah',
        'description': 'Kegiatan penulisan PKM',
        'quota': 50,
        'registration_type': 'Internal',
        'status': 'Planned',
        'members_count': 12,
        'schedules_count': 3,
      };

      final program = ProgramModel.fromJson(json);

      expect(program.id, 10);
      expect(program.divisionId, 2);
      expect(program.divisionName, 'Divisi Penalaran & Keilmuan');
      expect(program.picId, 4); // Must be members.id (4), not users.id (8)
      expect(program.picName, 'Muhammad Rizky');
      expect(program.picNim, '21051204050');
      expect(program.toJson()['pic_id'], 4);
    });

    test('ProgramModel handles null PIC cleanly', () {
      final json = {
        'id': 11,
        'division_id': 1,
        'division': {'id': 1, 'name': 'Divisi BPH'},
        'pic_id': null,
        'pic': null,
        'name': 'Rapat Kerja Tahunan',
        'status': 'Planned',
      };

      final program = ProgramModel.fromJson(json);

      expect(program.id, 11);
      expect(program.picId, isNull);
      expect(program.picName, isNull);
      expect(program.picNim, isNull);
    });

    test('PicCandidate formats label with name and NIM', () {
      const candidate = PicCandidate(
        memberId: 7,
        name: 'Siti Aminah',
        nim: '22051204012',
      );

      expect(candidate.memberId, 7);
      expect(candidate.name, 'Siti Aminah');
      expect(candidate.nim, '22051204012');
      expect(candidate.label, 'Siti Aminah (22051204012)');
    });

    test('PicCandidate handles empty NIM gracefully', () {
      const candidate = PicCandidate(
        memberId: 3,
        name: 'Admin Utama',
        nim: '',
      );

      expect(candidate.label, 'Admin Utama');
    });

    test('PicCandidate equality is based on memberId', () {
      const c1 = PicCandidate(memberId: 5, name: 'Budi', nim: '123');
      const c2 = PicCandidate(memberId: 5, name: 'Budi Santoso', nim: '12345');
      const c3 = PicCandidate(memberId: 6, name: 'Budi', nim: '123');

      expect(c1, equals(c2));
      expect(c1, isNot(equals(c3)));
    });
  });
}
