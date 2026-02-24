/// 글로벌 공통 Starter Sets 데이터
/// 저장소에 저장하지 않음 – 사용 시 Roulette 객체로 복사하여 저장
/// 'nameKey'/'categoryKey': AppLocalizations 키, 'itemKeys': 아이템 키 목록
/// Numbers 세트는 'items'를 직접 사용 (번역 불필요)
const List<Map<String, dynamic>> kStarterSets = [
  {
    'id': 'starter_001',
    'emoji': '✅',
    'nameKey': 'starterSetYesNo',
    'categoryKey': 'starterCatDecision',
    'itemKeys': ['itemYes', 'itemNo','itemYes', 'itemNo','itemYes', 'itemNo','itemYes', 'itemNo','itemYes', 'itemNo'],
  },
  {
    'id': 'starter_002',
    'emoji': '🎭',
    'nameKey': 'starterSetTruthDare',
    'categoryKey': 'starterCatFun',
    'itemKeys': ['itemTruth', 'itemDare', 'itemTruth', 'itemDare', 'itemTruth', 'itemDare', 'itemTruth', 'itemDare', 'itemTruth', 'itemDare'],
  },
  {
    'id': 'starter_003',
    'emoji': '👥',
    'nameKey': 'starterSetTeamSplit',
    'categoryKey': 'starterCatTeam',
    'itemKeys': ['itemTeamA', 'itemTeamB', 'itemTeamC', 'itemTeamD', 'itemTeamE', 'itemTeamF', 'itemTeamG', 'itemTeamH'],
  },
  {
    'id': 'starter_004',
    'emoji': '🔢',
    'nameKey': 'starterSetNumbers',
    'categoryKey': 'starterCatNumbers',
    'items': ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'],
  },
  {
    'id': 'starter_005',
    'emoji': '🍕',
    'nameKey': 'starterSetFood',
    'categoryKey': 'starterCatFood',
    'itemKeys': ['itemPizza', 'itemBurger', 'itemPasta', 'itemSalad', 'itemSushi'],
  },
  {
    'id': 'starter_006',
    'emoji': '🎲',
    'nameKey': 'starterSetRandomOrder',
    'categoryKey': 'starterCatGame',
    'itemKeys': ['itemPlayer1', 'itemPlayer2', 'itemPlayer3', 'itemPlayer4', 'itemPlayer5', 'itemPlayer6', 'itemPlayer7', 'itemPlayer8'],
  },
  {
    'id': 'starter_007',
    'emoji': '🏆',
    'nameKey': 'starterSetWinnerPick',
    'categoryKey': 'starterCatDecision',
    'itemKeys': ['itemCandidateA', 'itemCandidateB', 'itemCandidateC', 'itemCandidateD', 'itemCandidateE', 'itemCandidateF', 'itemCandidateG', 'itemCandidateH'],
  },
];
