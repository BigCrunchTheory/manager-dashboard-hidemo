const express = require('express');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

const port = process.env.PORT || 4000;

function parseTimeRange(q) {
  // q: { preset: 'TODAY' | 'THIS_MONTH' | ... , from: '2025-08-01', to: '2025-08-27' }
  const presets = new Set(['TODAY','YESTERDAY','THIS_WEEK','THIS_MONTH','LAST_WEEK','LAST_MONTH','ALL_TIME']);
  if (q.preset && presets.has(q.preset)) return { type: 'preset', preset: q.preset };
  if (q.from && q.to) return { type: 'custom', from: q.from, to: q.to };
  return { type: 'preset', preset: 'TODAY' };
}

app.get('/api/v1/manager/locations', (req, res) => {
  const range = parseTimeRange(req.query);

  // sample logic to vary data by preset
  let averageLocationOnline = 90;
  let totalLocationsCount = 5;
  if (range.type === 'preset') {
    switch(range.preset) {
      case 'TODAY': averageLocationOnline = 91; break;
      case 'YESTERDAY': averageLocationOnline = 88; break;
      case 'THIS_WEEK': averageLocationOnline = 89; break;
      case 'THIS_MONTH': averageLocationOnline = 87; break;
      case 'LAST_WEEK': averageLocationOnline = 85; break;
      case 'LAST_MONTH': averageLocationOnline = 82; break;
      case 'ALL_TIME': averageLocationOnline = 93; break;
    }
  } else {
    // simple deterministic pseudo-random based on date length
    const len = range.from.length + range.to.length;
    averageLocationOnline = 75 + (len % 25);
  }

  res.json({ averageLocationOnline, totalLocationsCount, timeRange: range });
});

app.get('/api/v1/manager/locations/cards', (req, res) => {
  // return a list of 3 sample locations
  const data = [
    {
      locationId: 'loc_12345',
      stationsInfo: [
        {
          cabinetId: 'cab_001',
          currentOnlineStatus: 1,
          thirtyDaysOnlinePercentage: 95,
          onlinePercentageSinceInstallation: 98
        },
        {
          cabinetId: 'cab_002',
          currentOnlineStatus: 0,
          thirtyDaysOnlinePercentage: 88,
          onlinePercentageSinceInstallation: 90
        }
      ],
      address: '123 Main Street, Kyiv',
      locationNumber: 'LC-2024',
      totalRevenue: 15234.75,
      shopStart: '08:00',
      shopEnd: '22:00',
      locationType: 'Mall',
      hasCompetitors: true,
      isGoodVisibility: false,
      area: 'Central',
      taughtStaffCount: 5,
      locationCategory: 'Premium',
      establishmentNumber: 'EST-9087'
    },
    {
      locationId: 'loc_67890',
      stationsInfo: [
        {
          cabinetId: 'cab_101',
          currentOnlineStatus: 1,
          thirtyDaysOnlinePercentage: 92,
          onlinePercentageSinceInstallation: 96
        }
      ],
      address: '456 Side Ave, Lviv',
      locationNumber: 'LC-2025',
      totalRevenue: 8234.50,
      shopStart: '09:00',
      shopEnd: '21:00',
      locationType: 'Street',
      hasCompetitors: false,
      isGoodVisibility: true,
      area: 'North',
      taughtStaffCount: 2,
      locationCategory: 'Standard',
      establishmentNumber: 'EST-1122'
    },
    {
      locationId: 'loc_24680',
      stationsInfo: [],
      address: '789 Market Rd, Odesa',
      locationNumber: 'LC-2026',
      totalRevenue: 0,
      shopStart: '10:00',
      shopEnd: '20:00',
      locationType: 'Kiosk',
      hasCompetitors: true,
      isGoodVisibility: false,
      area: 'South',
      taughtStaffCount: 0,
      locationCategory: 'Economy',
      establishmentNumber: 'EST-3344'
    }
  ];

  res.json(data);
});

app.listen(port, () => {
  console.log(`Mock server listening on http://localhost:${port}`);
});
