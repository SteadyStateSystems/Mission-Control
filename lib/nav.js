export const navItems = [
  { label: 'Task Board', slug: 'task-board' },
  { label: 'Calendar', slug: 'calendar' },
  { label: 'Projects', slug: 'projects' },
  { label: 'Memories', slug: 'memories' },
  { label: 'Docs', slug: 'docs' },
  { label: 'Team', slug: 'team' },
  { label: 'Office', slug: 'office' }
];

export function sectionTitleFromSlug(slug = '') {
  const found = navItems.find((x) => x.slug === slug);
  return found ? found.label : 'Task Board';
}
