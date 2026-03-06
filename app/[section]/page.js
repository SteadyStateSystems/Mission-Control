import { notFound } from 'next/navigation';
import MissionControlView from '../components/MissionControlView';
import { navItems, sectionTitleFromSlug } from '../../lib/nav';

export function generateStaticParams() {
  return navItems.map((item) => ({ section: item.slug }));
}

export default function SectionPage({ params }) {
  const { section } = params;
  const isValid = navItems.some((x) => x.slug === section);
  if (!isValid) return notFound();

  return <MissionControlView activeLabel={sectionTitleFromSlug(section)} />;
}
